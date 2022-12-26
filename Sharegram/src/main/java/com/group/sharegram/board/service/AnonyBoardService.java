package com.group.sharegram.board.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.domain.AnonyBoardDTO;

public interface AnonyBoardService {
	
	public void findAllAnonyList(HttpServletRequest request, Model model);
	
	public void save(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	
	public AnonyBoardDTO getAnonyByNo(int anonyNo);
	
	// public void modifyAnony(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	public int removeAnony(int anonyNo);
	
	public void findAnony(HttpServletRequest request, Model modle);
	
	// public int increaseHit(int anonyNo);
	
	// public void findAnonyList(HttpServletRequest request, Model model);
}
