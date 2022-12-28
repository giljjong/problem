package com.group.sharegram.mail.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.group.sharegram.mail.domain.MailAtchDTO;
import com.group.sharegram.mail.domain.MailDTO;
import com.group.sharegram.mail.domain.ReceiversDTO;
import com.group.sharegram.mail.service.MailService;

@Controller
public class MailController {
	
	@Autowired
	private MailService mailService;
	
	@GetMapping("/mail/list")
	public String wel() {
		return "mail/listReceive";
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
	
	@ResponseBody
	@PostMapping("/mail/send")
	public Map<String, Object> save(MultipartHttpServletRequest multipartRequest, MailDTO mail) {
		System.out.println(mail.toString());
		return mailService.saveMail(multipartRequest, mail);
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
	
	@PostMapping(value="/mail/write/delivery", produces="application/json; charset=UTF-8")
	public String writeDeliveryMail(@RequestParam("mailNo") int mailNo, ReceiversDTO receivData, RedirectAttributes rAttr) {
		List<MailAtchDTO> attachList = mailService.getMailAttach(mailNo);
		rAttr.addFlashAttribute("mailNo", mailNo);
		rAttr.addFlashAttribute("attachList", attachList);
		rAttr.addFlashAttribute("attachCnt", attachList.size());
		rAttr.addFlashAttribute("receivData", receivData);
		rAttr.addFlashAttribute("type", "FW");
		return "redirect:/mail/write";
	}
	
	@ResponseBody
	@PostMapping(value="/mail/change/readCheck", produces="application/json; charset=UTF-8")
	public Map<String, Object> changeReadCheck(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam(value="readCheck[]")  List<String> readCheck, HttpServletRequest request) {
		return mailService.changeRead(mailNo, readCheck, request);
	}
	
	@ResponseBody
	@PostMapping(value="/delete/mail/trash", produces="application/json; charset=UTF-8")
	public Map<String, Object> moveInTrash(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam("receiveType") String receiveType, HttpServletRequest request) {
		return mailService.moveInTrash(mailNo, receiveType, request);
	}
	
	@ResponseBody
	@GetMapping(value="/get/trash", produces="application/json; charset=UTF-8")
	public Map<String, Object> getTrashList(HttpServletRequest request) {
		String deleteCheck = "Y";
		String receiveType = "trash";
		return mailService.getReceiveMailList(request, deleteCheck, receiveType);
	}
	
	@ResponseBody
	@GetMapping(value="/get/send", produces="application/json; charset=UTF-8")
	public Map<String, Object> getSendList(HttpServletRequest request) {
		String deleteCheck = "N";
		String receiveType = "send";
		return mailService.getReceiveMailList(request, deleteCheck, receiveType);
	}
	
	@ResponseBody
	@PostMapping(value="/mail/summernote/uploadImage", produces="application/json; charset=UTF-8")
	public Map<String, Object> uploadImage(MultipartHttpServletRequest multipartRequest) {
		return mailService.saveSummernoteImage(multipartRequest);
	}
	
	@ResponseBody
	@GetMapping(value="/mail/download", produces="application/json; charset=UTF-8")
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, @RequestParam("fileNo") int fileNo) {
		return mailService.download(userAgent, fileNo);
	}
	
	@ResponseBody
	@GetMapping(value="/mail/downloadAll", produces="application/json; charset=UTF-8")
	public ResponseEntity<Resource> downloadAll(@RequestHeader("User-Agent") String userAgent, @RequestParam("mailNo") int mailNo) {
		return mailService.downloadAll(userAgent, mailNo);
	}
	
	@ResponseBody
	@PostMapping(value="/delete/mail/completely", produces="application/json; charset=UTF-8")
	public Map<String, Object> deleteCompletely(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam(value="receiveType[]") List<String> receiveType, HttpServletRequest request) {
		return mailService.deleteReceiverData(mailNo, receiveType, request);
	}
	
	@ResponseBody
	@PostMapping(value="/restore/mail", produces="application/json; charset=UTF-8")
	public Map<String, Object> restoreMail(@RequestParam(value="mailNo[]") List<String> mailNo, @RequestParam(value="receiveType[]") List<String> receiveType, HttpServletRequest request){
		return mailService.restoreReceiverData(mailNo, receiveType, request);
	}
	
}
