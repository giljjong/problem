package com.group.sharegram.board.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.board.domain.UploadCommentDTO;
import com.group.sharegram.board.service.UploadCommentService;

@Controller
public class UploadCommentController {
	
	@Autowired
	private UploadCommentService uploadCommentService;
	
	@ResponseBody
	@GetMapping(value="/comment/getCount", produces="application/json")
	public Map<String, Object> getCount(@RequestParam("boardNo") int boardNo) {
		return uploadCommentService.getUploadCommentCount(boardNo);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/add", produces="application/json")
	public Map<String, Object> add(UploadCommentDTO comment, HttpServletRequest request) {
		return uploadCommentService.addUploadComment(comment,request);
	}
	
	@ResponseBody
	@GetMapping(value="/comment/list", produces="application/json")
	public Map<String, Object> list(HttpServletRequest request) {
		return uploadCommentService.getUploadCommentList(request);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/remove", produces="application/json")
	public Map<String, Object> remove(@RequestParam("cmtNo") int cmtNo){
		return uploadCommentService.removeUploadComment(cmtNo);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/reply/add", produces="application/json")
	public Map<String, Object> replyAdd(UploadCommentDTO reply, HttpServletRequest request){
		return uploadCommentService.addUploadReply(reply, request);
	}
	
}
