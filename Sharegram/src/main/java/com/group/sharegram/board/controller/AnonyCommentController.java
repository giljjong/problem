package com.group.sharegram.board.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.board.service.AnonyCommentService;

@Controller
public class AnonyCommentController {

	@Autowired
	private AnonyCommentService commentService;
	
	@ResponseBody
	@GetMapping(value="/anonycomment/getCount", produces="application/json")
	public Map<String, Object> getCount(@RequestParam("anonyNo") int anonyNo) {
		return commentService.getCommentCount(anonyNo);
	}
	
	@ResponseBody
	@PostMapping(value="/anonycomment/add", produces="application/json")
	public Map<String, Object> add(HttpServletRequest request) {
		return commentService.addComment(request);
	}
	
	@ResponseBody
	@GetMapping(value="/anonycomment/list", produces="application/json")
	public Map<String, Object> list(HttpServletRequest request) {
		return commentService.getCommentList(request);
	}
	
	@ResponseBody
	@PostMapping(value="/anonycomment/remove", produces="application/json")
	public Map<String, Object> remove(@RequestParam("commentNo") int commentNo){
		return commentService.removeComment(commentNo);
	}
	
	@ResponseBody
	@PostMapping(value="/anonycomment/reply/add", produces="application/json")
	public Map<String, Object> replyAdd(HttpServletRequest request){
		return commentService.addReply(request);
	}
	
	
	
}
