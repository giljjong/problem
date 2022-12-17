package com.gdu.mail.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class MailIUtil {
	
	static final Logger LOGGER = LoggerFactory.getLogger(MailIUtil.class);
	
	public boolean sendMail(EmpAddrDTO fromInfo, MailDTO mail) {
		
		// 이메일 전송을 위한 필수 속성을 Properties 객체로 생성
		Properties properties = new Properties();
		properties.put("mail.smtp.host", "smtp.sharegram.com");	
		properties.put("mail.smtp.port", "25");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");

		// 사용자 정보를 javax.mail. Session에 저장
		Session session = Session.getInstance(properties, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromInfo.getEmail(), fromInfo.getPassword());
			}
		});
		
		// 이메일 작성 및 전송
		try {
			
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(fromInfo.getEmail(), fromInfo.getName()));
			message.setRecipients(Message.RecipientType.TO,  mail2Addr(mail.getToAddr()));
			if(mail.getCcAddr() != null){
				message.setRecipients(Message.RecipientType.CC,  mail2Addr(mail.getCcAddr()));
			}
			message.setSubject(mail.getSubject());
			message.setContent(mail.getMailContent(), "text/html; charset=UTF-8");
			
			Transport.send(message);
			return true;
		} catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public InternetAddress[] mail2Addr(String[] maillist) {
		InternetAddress[] addressTo = new InternetAddress[maillist.length];
		try {
			for (int i = 0; i < maillist.length; i++) {
				if (!"".equals(maillist[i])) addressTo[i] = new InternetAddress(maillist[i]);
			}
		} catch (AddressException e) {
            LOGGER.error("mail2Addr");
		}

		return addressTo;
	}
	
	public String checkDateFormat(Date sendDate) {
		
		try {
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
			SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
			String todayfm = dateFormat.format(new Date(System.currentTimeMillis()));
			String yearfm = yearFormat.format(new Date(System.currentTimeMillis()));
			
			Date today = new Date(dateFormat.parse(todayfm).getTime());
			Date year = new Date(yearFormat.parse(yearfm).getTime());
			
			boolean result = sendDate.before(today);
			
			if(result) {
				boolean yearResult = sendDate.before(year);
				
				if(yearResult) {
					return "overYear";
				} else {
					return "overDay";
				}
			} else {
				return "inToday";
			}
		
		} catch(Exception e) {
			e.printStackTrace();
			return "dateFormatError";
		}
	}
	
}
