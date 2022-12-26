package com.group.sharegram.board.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AnonyCommentService {
	
	public Map<String, Object> getCommentCount(int anonyNo);
	public Map<String, Object> addComment(HttpServletRequest request);
	public Map<String, Object> getCommentList(HttpServletRequest request);
	public Map<String, Object> removeComment(int commentNo);
	public Map<String, Object> addReply(HttpServletRequest request);
}
