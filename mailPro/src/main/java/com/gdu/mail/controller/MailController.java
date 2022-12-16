package com.gdu.mail.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.service.MailService;

@Controller
public class MailController {
	
	@Autowired
	private MailService mailService;
	
	@GetMapping("/")
	public String welcome() {
		return "index";
	}
	
	@GetMapping("/mail/form")
	public String mailForm() {
		return "mail/form";
	}
	
	@GetMapping("/write/Form")
	public String write() {
		return "mail/writeMail";
	}
	
	@GetMapping("/mail/writeMail")
	public String go() {
		return "mail/writeMail";
	}
	
	@PostMapping("/mail/send")
	public String save(HttpServletRequest request, HttpServletResponse response, MailDTO mail) {
		mailService.insertMail(request, response, mail);
		return "redirect:mail/sendSuccess";
	}
	
}
