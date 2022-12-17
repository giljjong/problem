package com.gdu.mail.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@GetMapping("/mail/main")
	public String mailForm(HttpServletRequest request, Model model) {
		mailService.selectReceiveMail(request, model);
		return "mail/listReceive";
	}
	
	@GetMapping("/write/Form")
	public String write() {
		return "mail/writeMail";
	}
	
	@GetMapping("/mail/write")
	public String go() {
		return "mail/writeMail";
	}
	
	@PostMapping("/mail/send")
	public String save(HttpServletRequest request, HttpServletResponse response, MailDTO mail) {
		mailService.insertMail(request, response, mail);
		return "redirect:/mail/sendSuccess";
	}
	
	@GetMapping("/mail/sendSuccess")
	public String success() {
		return "mail/sendSuccess";
	}
	
	@GetMapping("/mail/listReceive")
	public String listMail(HttpServletRequest request, Model model) {
		mailService.selectReceiveMail(request, model);
		return "mail/listReceive";
	}
	
}
