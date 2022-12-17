package com.gdu.mail.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;
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
		System.out.println(mail.getToAddr().toString());
		
    	if (!mail.getStrCc().equals("")) mail.setCcAddr(mail.getStrCc().split(";"));
    	
    	try {

    		mailUtil.sendMail(mailUser, mail);
    		mailMapper.insertMail(mail);
    		String[] toAddrs = mail.getToAddr();
    		
    		Map<String, Object> map = new HashMap<String, Object>();
    		int recieveEmp = 0;
    		
    		for(int i = 0; i < toAddrs.length; i++) {
    			
    			map.put("empNo", toAddrs[i].substring(0, toAddrs[i].indexOf("@")));
    			
    			recieveEmp = empMapper.selectEmpByMap(map).getEmpNo();
    			mailMapper.insertReceivers(recieveEmp);
    			
    			recieveEmp = 0;
    			map.clear();

            }
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	
	}
	
	@Override
	public void selectReceiveMail(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Optional<String> record = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(record.orElse("20"));
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		int totalRecord = mailMapper.selectReceiveCount(empNo);
		
		pageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		List<MailDTO> mailList = mailMapper.selectReceiveList(map);
		
		for (MailDTO mailInfo : mailList) {
            
			EmpAddrDTO addr = addrMapper.selectEmpAddrByNo(mailInfo.getEmpNo());
			
			if(addr.getName() != null) {
				mailInfo.setEmpName(addr.getName());
			}
			
			Date sendDate = mailInfo.getSendDate();
			SimpleDateFormat dateFormat;
			
			System.out.println(mailUtil.checkDateFormat(sendDate));
			
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
	
	
}
