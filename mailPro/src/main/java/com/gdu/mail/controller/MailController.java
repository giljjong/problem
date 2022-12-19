package com.gdu.mail.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.mail.domain.EmpAddrDTO;
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
		mailService.getReceiveMailList(request, model);
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
		mailService.getReceiveMailList(request, model);
		return "mail/listReceive";
	}
	
	@GetMapping("/mail/receive/detail")
	public String getMailInfo(HttpServletRequest request, Model model) {
		mailService.getReceiveMailInfo(request, model);
		return "mail/readReceive";
	}
	
	@PostMapping("/mail/write/new")
	public String writeClickEmail(@RequestParam("email") String email, RedirectAttributes rAttr) {
		rAttr.addFlashAttribute("email", email);
		return "redirect:/mail/get/write";
	}
	
	@GetMapping("/mail/get/write")
	public String writeRedirect(Model model) {
		return "mail/getMailWrite";
	}
	
	@PostMapping("/mail/write/reply")
	public String writeReplyMail(@RequestParam("mailNo") int mailNo, RedirectAttributes rAttr) {
		rAttr.addFlashAttribute("mailNo", mailNo);
		return "redirect:/mail/get/write";
	}
	
	@ResponseBody
	@PostMapping(value="/mail/get/reply", produces="application/json; charset=UTF-8")
	public Map<String, Object> getWriteInfo(HttpServletRequest request, Model model){
		return mailService.getReceiveMailInfo(request, model);
	}
	
}
