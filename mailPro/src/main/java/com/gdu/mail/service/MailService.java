package com.gdu.mail.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;

public interface MailService {
	public void insertMail(HttpServletRequest request, HttpServletResponse response, MailDTO mail);
	public Map<String, Object> getReceiveMailList(HttpServletRequest request,  String deleteCheck, String receiveType);
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model, ReceiversDTO receivData);
	public Map<String, Object> changeRead(int mailNo, String readCheck, HttpServletRequest request);
	public Map<String, Object> moveInTrash(List<String> mailNo, String receiveType, HttpServletRequest request);
}
