package com.gdu.mail.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;
import com.gdu.mail.service.MailService;

@Controller
public class MailController {
	
	@Autowired
	private MailService mailService;
	
	@GetMapping("/")
	public String welcome() {
		return "index";
	}
	
	@GetMapping("/mail/folder/list")
	public String listMail() {
		return "mail/listReceive";
	}
	
	@GetMapping("/mail/folder/trash")
	public String trashMail() {
		return "mail/listTrash";
	}
	
	@GetMapping("/mail/folder/send")
	public String sendMail() {
		return "mail/listSend";
	}
	
	@GetMapping("/mail/write")
	public String go() {
		return "mail/writeMail";
	}
	
	@PostMapping("/mail/send")
	public String save(HttpServletRequest request, HttpServletResponse response, MailDTO mail) {
		mailService.saveMail(request, response, mail);
		return "redirect:/mail/sendSuccess";
	}
	
	@GetMapping("/mail/sendSuccess")
	public String success() {
		return "mail/sendSuccess";
	}
	
	@PostMapping("/mail/receive/detail")
	public String getMailInfo(HttpServletRequest request, Model model, ReceiversDTO receivData) {
		mailService.getReceiveMailInfo(request, model, receivData);
		return "mail/readReceive";
	}
	
	@PostMapping("/mail/write/new")
	public String writeClickEmail(@RequestParam("email") String email, RedirectAttributes rAttr) {
		rAttr.addFlashAttribute("email", email);
		return "redirect:/mail/write";
	}
	
	@PostMapping("/mail/write/reply")
	public String writeReplyMail(@RequestParam("mailNo") int mailNo, ReceiversDTO receivData,  RedirectAttributes rAttr) {
		rAttr.addFlashAttribute("mailNo", mailNo);
		rAttr.addFlashAttribute("receivData", receivData);
		rAttr.addFlashAttribute("type", "RE");
		return "redirect:/mail/write";
	}
	
	@ResponseBody
	@GetMapping(value="/list/mail", produces="application/json; charset=UTF-8")
	public Map<String, Object> getMailList(HttpServletRequest request){
		String deleteCheck = "N";
		String receiveType = "To";
		return mailService.getReceiveMailList(request, deleteCheck, receiveType);
	}
	
	@ResponseBody
	@PostMapping(value="/mail/get/reply", produces="application/json; charset=UTF-8")
	public Map<String, Object> getWriteInfo(HttpServletRequest request, Model model, ReceiversDTO receivData){
		return mailService.getReceiveMailInfo(request, model, receivData);
	}
	
	@PostMapping("/mail/write/delivery")
	public String writeDeliveryMail(@RequestParam("mailNo") int mailNo, ReceiversDTO receivData, RedirectAttributes rAttr) {
		rAttr.addFlashAttribute("mailNo", mailNo);
		rAttr.addFlashAttribute("receivData", receivData);
		rAttr.addFlashAttribute("type", "FW");
		return "redirect:/mail/write";
	}
	
	@ResponseBody
	@PostMapping("/mail/change/readCheck")
	public Map<String, Object> changeReadCheck(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam(value="readCheck[]")  List<String> readCheck, HttpServletRequest request) {
		return mailService.changeRead(mailNo, readCheck, request);
	}
	
	@ResponseBody
	@PostMapping("/remove/mail/trash")
	public Map<String, Object> moveInTrash(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam("receiveType") String receiveType, HttpServletRequest request) {
		return mailService.moveInTrash(mailNo, receiveType, request);
	}
	
	@ResponseBody
	@GetMapping("/get/trash")
	public Map<String, Object> getTrashList(HttpServletRequest request) {
		String deleteCheck = "Y";
		String receiveType = "trash";
		return mailService.getReceiveMailList(request, deleteCheck, receiveType);
	}
	
	@ResponseBody
	@GetMapping("/get/send")
	public Map<String, Object> getSendList(HttpServletRequest request) {
		String deleteCheck = "N";
		String receiveType = "send";
		return mailService.getReceiveMailList(request, deleteCheck, receiveType);
	}
	
	@ResponseBody
	@PostMapping("/mail/summernote/uploadImage")
	public Map<String, Object> uploadImage(MultipartHttpServletRequest multipartRequest) {
		return mailService.saveSummernoteImage(multipartRequest);
	}
	
}
