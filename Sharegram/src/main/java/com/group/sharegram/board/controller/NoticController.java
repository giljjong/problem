
package com.group.sharegram.board.controller;

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

import com.group.sharegram.board.service.NoticBoardService;

@Controller
public class NoticController {

	@Autowired
	private NoticBoardService noticBoardService;
	
	@GetMapping("/board/noticList")
	public String list(HttpServletRequest request, Model model) {
		noticBoardService.findAllNoticList(request, model);
		return "board/notic/list";
	}
	
	@GetMapping("/board/notic/write")
	public String write() {
		return "board/notic/write";
	}
	
	@ResponseBody
	@PostMapping(value="/board/noticImage", produces="application/json")
	public Map<String, Object> notic(MultipartHttpServletRequest multipartRequest) {
		return noticBoardService.saveSummernoteImage(multipartRequest);
	}
	
	@PostMapping("/board/notic/add")
	public void add(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		noticBoardService.save(multipartRequest, response);
	}
	
	@GetMapping("/board/notic/detail")
	public String detail(@RequestParam(value="noticNo", required=false, defaultValue="0") int noticNo, Model model) {
		model.addAttribute("noticBoard", noticBoardService.getNoticByNo(noticNo));
		return "board/notic/detail";
	}
	
	@GetMapping("/board/notic/edit")
	public String content(@RequestParam(value="noticNo", required=false, defaultValue="0") int noticNo, Model model) {
		model.addAttribute("noticBoard", noticBoardService.getNoticByNo(noticNo));
		return "board/notic/edit";
	}
	
	@PostMapping("/board/notic/modify")
	public void modify(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		noticBoardService.modifyNotic(multipartRequest, response);
	}
	
	@PostMapping("/board/notic/remove")
	public void remove(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("컨트롤러 왔다.");
		noticBoardService.removeNotic(request, response);
		System.out.println("컨트롤러 끝났따");
	}
	
	@GetMapping("/board/notic/incrase/hit")
	public String incraseHit(@RequestParam(value = "noticNo", required = false, defaultValue = "0")int noticNo) {
		int result = noticBoardService.increaseHit(noticNo);
		if(result > 0 ) {
			return "redirect:/board/notic/detail?noticNo=" + noticNo;
		} else {
			return "redirect:/board/notic/list";
		}
	}
	
	
}
