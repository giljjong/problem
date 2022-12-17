package com.gdu.mail.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.gdu.mail.domain.MailDTO;

public interface MailService {
	public void insertMail(HttpServletRequest request, HttpServletResponse response, MailDTO mail);
	public void selectReceiveMail(HttpServletRequest request, Model model);
}
