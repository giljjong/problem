package com.group.sharegram.board.service;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.domain.UploadBoardDTO;

public interface UploadBoardService {
	
	// 자료실 목록
	public void findAllUploadList(HttpServletRequest request, Model model);
	
	// public UploadBoardDTO getUplaodBoardByNo(int uploadBoardNo);
	
	// 써머노트 이미지
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest);
	
	// 게시글 작성 완료
	public void save(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	
	// 게시글 번호
	// public void getUploadByNo(int uploadNo, Model model);
	public UploadBoardDTO getUploadByNo(int uploadNo);
	
	
	public ResponseEntity<byte[]> display(int attachNo);
	
	// 자료 다운로드(String 타입 chk)
	public ResponseEntity<Resource> download(String empNo, int attachNo);
	
	// 일괄 다운로드
	public ResponseEntity<Resource> downloadAll(String empNo, int uploadNo);
	
	// 수정
	public void modifyUpload(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	
	// 자료 삭제
	public void removeAttachByAttachNo(int attachNo);
	
	// 게시글 삭제
	public void removeUpload(HttpServletRequest multipartRequest, HttpServletResponse response);
	
	// 조회수
	public int increaseHit(int uploadNo);
	
	// findUpload 추가
	
	
}
