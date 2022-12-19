package com.gdu.mail.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.mail.domain.MailDTO;

public interface MailService {
	public void insertMail(HttpServletRequest request, HttpServletResponse response, MailDTO mail);
	public void getReceiveMailList(HttpServletRequest request, Model model);
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model);
}
