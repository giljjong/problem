package com.gdu.mail.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.mail.domain.MailAtchDTO;
import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;

public interface MailService {
	public Map<String, Object> saveMail(MultipartHttpServletRequest multipartRequest, HttpServletResponse response, MailDTO mail);
	public Map<String, Object> getReceiveMailList(HttpServletRequest request,  String deleteCheck, String receiveType);
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model, ReceiversDTO receivData);
	public Map<String, Object> changeRead(List<String> mailNo, List<String> readCheck, HttpServletRequest request);
	public Map<String, Object> moveInTrash(List<String> mailNo, String receiveType, HttpServletRequest request);
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest);
	public ResponseEntity<Resource> download(String userAgent, int fileNo);
	public ResponseEntity<Resource> downloadAll(String userAgent, int mailNo);
	public List<MailAtchDTO> getMailAttach(int mailNo);
}
