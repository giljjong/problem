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
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	
	}
	
	@Override
	public void getReceiveMailList(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Optional<String> record = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(record.orElse("20"));
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		int totalRecord = mailMapper.selectReceiveMailCount(empNo);
		
		pageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		List<MailDTO> mailList = mailMapper.selectReceiveMailList(map);
		
		for (MailDTO mailInfo : mailList) {
            System.out.println(mailInfo.getEmpNo());
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
		
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "/mail/listReceive"));
		model.addAttribute("mailList", mailList);
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("NReadCnt", mailMapper.selectReadNotCount(empNo));
		
		System.out.println(mailList);
	}
	
	@Override
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("mailNo"));
		int mailNo = Integer.parseInt(opt.orElse("0"));
		
		Map<String, Object> map = new HashMap<>();
		map.put("mailNo", mailNo);
		
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
		
		model.addAttribute("mail", mail);
		model.addAttribute("addrList", addrList);
		
		Map<String, Object> mailInfo = new HashMap<>();
		mailInfo.put("mail", mail);
		mailInfo.put("addrList", addrList);
		
		return mailInfo;
		
	}
	
}
