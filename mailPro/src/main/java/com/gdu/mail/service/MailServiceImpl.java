package com.gdu.mail.service;

import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.mapper.MailMapper;
import com.gdu.mail.util.SendMail;

@Service
public class MailServiceImpl implements MailService {
	
	@Autowired
	private SendMail sendMail;
	
	@Autowired
	private MailMapper mailMapper;
	
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

    		sendMail.sendMail(mailUser, mail);
    		mailMapper.insertMail(mail);
    		String[] toAddrs = mail.getToAddr();
    		for(int i = 0; i < toAddrs.length; i++) {
    			
    			/*
    			toAddrs[i];
    			 String 배열에서 @sharegram.com을 제외하고 하나씩 뽑아서 mailMapper.insertRecievers 시키기(참조도 모두 다)
    			 
    			*/
            }
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	
	}
	
	
	
	
}
