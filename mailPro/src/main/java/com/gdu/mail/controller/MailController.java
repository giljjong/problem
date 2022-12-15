package com.gdu.mail.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MailController {
	
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
		return "mail/writeForm";
	}
	
	@GetMapping("/mail/writeMail")
	public String go() {
		return "mail/writeMail";
	}
	
}
