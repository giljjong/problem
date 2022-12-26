package com.group.sharegram.board.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.group.sharegram.board.domain.UploadCommentDTO;

public interface UploadCommentService {
	   public Map<String, Object> getUploadCommentCount(int boardNo);
	   public Map<String, Object> addUploadComment(UploadCommentDTO comment, HttpServletRequest request);
	   public Map<String, Object> getUploadCommentList(HttpServletRequest request);
	   public Map<String, Object> removeUploadComment(int cmtNo);
	   public Map<String, Object> addUploadReply(UploadCommentDTO reply, HttpServletRequest request);
	   
}