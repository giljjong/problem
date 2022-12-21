package com.gdu.mail.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;

@Component
public class MailIUtil {
	
	@Autowired
	private MyFileUtil myFileUtil;
	
	static final Logger LOGGER = LoggerFactory.getLogger(MailIUtil.class);
	
	public boolean sendMail(EmpAddrDTO fromInfo, MailDTO mail, String[] summernoteImageNames) {
		
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
			// message.setContent(mail.getMailContent(), "text/html; charset=UTF-8");
			message.setContent(new MimeMultipart());
			
			Multipart mp = (Multipart) message.getContent();
			mp.addBodyPart(getContents(mail.getMailContent()));
			
			// mp.addBodyPart(getFileAttachment("no", ""));
			if(summernoteImageNames !=  null) {
				for(int i = 0; i < summernoteImageNames.length; i++) {
					mp.addBodyPart(getImage(summernoteImageNames[i], "image" + i));
				}
			}
			
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
	
	 // 이미지를 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
	  private BodyPart getImage(String filename, String contextId) throws MessagingException {
		String path = myFileUtil.getSummernotePath();
	    // 파일을 읽어와서 BodyPart 클래스로 받는다.
	    BodyPart mbp = getFileAttachment(filename, path);
	    if (contextId != null) {
	      // ContextId 설정
	      mbp.setHeader("Content-ID", "<" + contextId + ">");
	    }
	    return mbp;
	  }
	  
	  // 파일을 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
	  private BodyPart getFileAttachment(String filename, String path) throws MessagingException {
	    // BodyPart 생성
	    BodyPart mbp = new MimeBodyPart();
	    // 파일 읽어서 BodyPart에 설정(바운더리 변환)
	    File file = new File(path, filename);
	    DataSource source = new FileDataSource(file);
	    mbp.setDataHandler(new DataHandler(source));
	    mbp.setDisposition(Part.ATTACHMENT);
	    mbp.setFileName(file.getName());
	    return mbp;
	  }
	  
	  // 메일의 본문 내용 설정
	  private BodyPart getContents(String html) throws MessagingException {
	    BodyPart mbp = new MimeBodyPart();
	    
	    for(int i = 0; i < 10; i++) {
			if(!html.contains("/mail")) {
				break;
			}
			i++;
			html = html.replace(html.substring(html.indexOf("/mail"), html.indexOf("style") - 2), "image" + i);
			html = html.replaceFirst("style", "styl");
		}
	    
		html = html.replace("styl", "style");
	    mbp.setContent(html, "text/html; charset=utf-8");
	    return mbp;
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
