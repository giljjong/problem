package com.gdu.mail.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;
import com.gdu.mail.mapper.AddrMapper;
import com.gdu.mail.mapper.EmpMapper;
import com.gdu.mail.mapper.MailMapper;
import com.gdu.mail.util.PageUtil;
import com.gdu.mail.util.MailIUtil;

@Service
public class MailServiceImpl implements MailService {
	
	@Autowired
	private MailIUtil mailUtil;
	
	@Autowired
	private MailMapper mailMapper;
	
	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private PageUtil pageUtil;
	
	@Autowired
	private AddrMapper addrMapper;
	
	@Transactional
	@Override
	public void insertMail(HttpServletRequest request, HttpServletResponse response, MailDTO mail) {
		EmpAddrDTO mailUser = (EmpAddrDTO)request.getSession().getAttribute("mailUser");
		int empNo = mailUser.getEmpNo();
		mail.setEmpNo(empNo);
		
		mail.setToAddr(mail.getStrTo().split(";"));
		
    	if (!mail.getStrCc().equals("")) mail.setCcAddr(mail.getStrCc().split(";"));
    	
    	try {

    		mailUtil.sendMail(mailUser, mail);
    		mailMapper.insertMail(mail);
    		String[] toAddrs = mail.getToAddr();
    		String[] toCcs = mail.getCcAddr();
    		
    		Map<String, Object> map = new HashMap<String, Object>();
    		int receiveEmp = 0;
    		
    		for(int i = 0; i < toAddrs.length; i++) {
    			receiveEmp = Integer.parseInt(toAddrs[i].substring(0, toAddrs[i].indexOf("@")));
    			map.put("empNo", receiveEmp);
    			
    			if(empMapper.selectEmpByMap(map) != null) {
    				map.put("receiveType", "To");
    				mailMapper.insertReceivers(map);
    			}
    			receiveEmp = 0;
    			map.clear();

            }
    		
    		if(toCcs != null) {
    			for(int i = 0; i < toCcs.length; i++) {
        			receiveEmp = Integer.parseInt(toCcs[i].substring(0, toCcs[i].indexOf("@")));
        			map.put("empNo", receiveEmp);
        			
        			if(empMapper.selectEmpByMap(map) != null) {
        				map.put("receiveType", "cc");
        				mailMapper.insertReceivers(map);
        			}
        			receiveEmp = 0;
        			map.clear();

                }
    		}
    		
    		map.put("empNo", empNo);
    		map.put("receiveType", "send");
    		mailMapper.insertReceivers(map);
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	
	}
	
	@ResponseBody
	@Override
	public Map<String, Object> getReceiveMailList(HttpServletRequest request, String deleteCheck, String receiveType) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Optional<String> record = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(record.orElse("20"));
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("deleteCheck", deleteCheck);
		
		if(receiveType.equals("trash")) {
			map.put("trash", "true");
		}
		
		int totalRecord = mailMapper.selectReceiveMailCount(map);
		if(receiveType.equals("send")) {
			totalRecord = mailMapper.selectSendMailCount(map);
		}
		
		pageUtil.setPageUtil(page, totalRecord, recordPerPage);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		List<MailDTO> mailList = mailMapper.selectReceiveMailList(map);
		int nReadCnt = mailMapper.selectReadNotReceiveCount(map);
		if(receiveType.equals("send")) {
			mailList = mailMapper.selectSendMailList(map);
			nReadCnt = mailMapper.selectReadNotSendCount(empNo);
		}
		
		for (MailDTO mailInfo : mailList) {
			EmpAddrDTO addr = addrMapper.selectEmpAddrByNo(mailInfo.getEmpNo());
			
			if(addr.getName() != null) {
				mailInfo.setEmpName(addr.getName());
			}
			
			Date sendDate = mailInfo.getSendDate();
			SimpleDateFormat dateFormat;
			
			switch(mailUtil.checkDateFormat(sendDate)) {
			case "overYear" : dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
							  break;
			case "overDay"  : dateFormat = new SimpleDateFormat("MM.dd HH:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
							  break;
			case "inToday"  : dateFormat = new SimpleDateFormat("a hh:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
			  				  break;
			default : break;
			}
			
        }
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("paging", pageUtil.getPaging(request.getContextPath() + "/mail/listReceive"));
		result.put("mailList", mailList);
		result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		result.put("totalRecord", totalRecord);
		result.put("nReadCnt", nReadCnt);
		
		return result;
	}
	
	@Override
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model, ReceiversDTO receivData) {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("mailNo"));
		int mailNo = Integer.parseInt(opt.orElse("0"));
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("mailNo", mailNo);
		map.put("deleteCheck", receivData.getDeleteCheck());
		
		String readCheck = null;
		if(receivData.getReceiveType().equals("send")) {
			readCheck = mailMapper.selectSendReceiverByMap(map).getReadCheck();
		} else {
			readCheck = mailMapper.selectReceiverByMap(map).getReadCheck();
			// 널 에러 잡기
		}
		
		if(readCheck != null && readCheck.equals("N")) {
			map.put("checkType", "READ_CHECK");
			map.put("check", "Y");
			mailMapper.updateCheckByMap(map);
		}
		
		MailDTO mail = mailMapper.selectMailByMap(map);
		mail.setEmpName(addrMapper.selectEmpAddrByNo(mail.getEmpNo()).getName());
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 (E) a hh:mm", Locale.KOREAN);
		mail.setReceiveDate(dateFormat.format(mail.getSendDate()));
		
		List<ReceiversDTO> receiverList = mailMapper.selectReceiverList(mailNo);
		
		List<EmpAddrDTO> addrList = new ArrayList<>();
		for (ReceiversDTO receiver : receiverList) {
			
			EmpAddrDTO addr = addrMapper.selectEmpAddrByNo(receiver.getEmpNo());
			addr.setReceiveType(receiver.getReceiveType());
			
			addrList.add(addr);
		}
		
		int totalRecord = mailMapper.selectReceiveMailCount(map);
		
		String in = request.getParameter("in");
		if(in.equals("trash")) {
			map.put("trash", "true");
		}
		int nReadCnt = mailMapper.selectReadNotReceiveCount(map);
		if(receivData.getReceiveType().equals("send")) {
			nReadCnt = mailMapper.selectReadNotSendCount(empNo);
		}
		
		model.addAttribute("mail", mail);
		model.addAttribute("addrList", addrList);
		model.addAttribute("nReadCnt", nReadCnt);
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("receivData", receivData);
		
		Map<String, Object> mailInfo = new HashMap<>();
		mailInfo.put("mail", mail);
		mailInfo.put("addrList", addrList);
		mailInfo.put("nReadCnt", nReadCnt);
		mailInfo.put("totalRecord", totalRecord);
		
		
		return mailInfo;
		
	}
	
	@Override
	public Map<String, Object> changeRead(int mailNo, String readCheck, HttpServletRequest request) {
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("mailNo", mailNo);
		map.put("checkType", "READ_CHECK");
		
		if(readCheck.equals("N")) {
			map.put("check", "Y");
		} else if(readCheck.equals("Y")) {
			map.put("check", "N");
		}
		
		int updateResult = mailMapper.updateCheckByMap(map);
		
		Map<String, Object> result = new HashMap<>();
		
		if(updateResult > 0) {
			result.put("isResult", true);
		}
		return result;
	}
	
	@Override
	public Map<String, Object> moveInTrash(List<String> mailNo, String receiveType, HttpServletRequest request) {
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("checkType", "DELETE_CHECK");
		
		int updateResult = 0;
		
		for(int i = 0; i < mailNo.size(); i++) {
			
			map.put("mailNo", mailNo.get(i));
			String deleteCheck = null;
			if(receiveType.equals("send")) {
				deleteCheck = mailMapper.selectSendReceiverByMap(map).getDeleteCheck();
			} else if(receiveType.equals("ToCc")) {
				deleteCheck = mailMapper.selectReceiverByMap(map).getDeleteCheck();
			}
			
			if(deleteCheck.equals("N")) {
				map.put("check", "Y");
				updateResult += mailMapper.updateCheckByMap(map);
			}
			
			map.clear();

		}
		
		Map<String, Object> result = new HashMap<>();
		
		if(updateResult == mailNo.size()) {
			result.put("isDelete", true);
		} else {
			result.put("isDelete", false);
		}

		
		return result;
	}
	
	
}
