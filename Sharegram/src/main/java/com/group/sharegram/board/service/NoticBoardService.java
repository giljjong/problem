package com.group.sharegram.board.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.domain.NoticBoardDTO;

public interface NoticBoardService {
	
	public void findAllNoticList(HttpServletRequest request, Model model);
	
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest);
	public void save(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	
	public NoticBoardDTO getNoticByNo(int noticNo);
	
	public void modifyNotic(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	public void removeNotic(HttpServletRequest request, HttpServletResponse response);
	
	public int increaseHit(int noticNo);
	
	// public void findNotic(HttpServletRequest request, Model model);
	
}
