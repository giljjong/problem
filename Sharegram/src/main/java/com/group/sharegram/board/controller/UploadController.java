package com.group.sharegram.board.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.service.UploadBoardService;

@Controller
public class UploadController {

	@Autowired
	private UploadBoardService uploadBoardService;
	
	// 자료실 목록
	@GetMapping("/board/uploadList")
	public String list(HttpServletRequest request, Model model) {
		uploadBoardService.findAllUploadList(request, model);
//		model.addAttribute("uploadList", uploadBoardService.findAllUploadList(  HttpServletRequest request, Model model) );
		return "board/upload/list";
	}
	
	// 게시글 작성
	@GetMapping("/board/upload/write")
	public String write() {
		return "board/upload/write";
	}
	
	// 써머노트 이미지
	@ResponseBody
	@PostMapping(value="/board/uploadImage", produces="application/json")
	public Map<String, Object> uploadImage(MultipartHttpServletRequest multipartRequest) {
		return uploadBoardService.saveSummernoteImage(multipartRequest);
	}
	
	
	// 게시글 추가
	@PostMapping("/board/upload/add")
	public void add(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		uploadBoardService.save(multipartRequest, response);
	}
	
	// 게시글 상세화면
	@GetMapping("/board/upload/detail")
	public String detail(@RequestParam(value="uploadNo", required=false, defaultValue="0") int uploadNo, Model model) {
		model.addAttribute("uploadBoard", uploadBoardService.getUploadByNo(uploadNo));
		//uploadBoardService.getUploadByNo(uploadNo, model);
		return "board/upload/detail";
	}
	
	@ResponseBody
	@GetMapping("/board/upload/display")
	public ResponseEntity<byte[]> display(@RequestParam int attachNo){
		return uploadBoardService.display(attachNo);
	}
	
	// 첨부자료 다움로드
	@ResponseBody
	@GetMapping("/board/upload/download")
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, @RequestParam("attachNo") int attachNo) {
		return uploadBoardService.download(userAgent, attachNo);
	}
	
	// 첨부자료 일괄 다운로드
	@ResponseBody
	@GetMapping("/board/upload/downloadAll")
	public ResponseEntity<Resource> downloadAll(@RequestHeader("User-Agent") String userAgent, @RequestParam("uploadNo") int uploadNo) {
		return uploadBoardService.downloadAll(userAgent, uploadNo);
	}
	
	// 수정
	@PostMapping("/board/upload/edit")
	public String edit(@RequestParam("uploadNo") int uploadNo, Model model) {
		model.addAttribute("uploadBoard", uploadBoardService.getUploadByNo(uploadNo));
		//ploadBoardService.getUploadByNo(uploadNo, model);
		return "/board/upload/edit";
	}
	
	@PostMapping("/board/upload/modify")
	public void modify(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		uploadBoardService.modifyUpload(multipartRequest, response);
	}
	
	// 첨부 삭제
	@GetMapping("/baord/upload/attach/remove")
	public String uploadAttachRemove(@RequestParam("uploadNo") int uploadNo, @RequestParam("attachNo") int attachNo) {
		uploadBoardService.removeAttachByAttachNo(attachNo);
		return "redirect:/upload/detail?uploadNo=" + uploadNo;
	}

	// 게시글 삭제
	@PostMapping("/board/upload/remove")
	public void remove(HttpServletRequest request, HttpServletResponse response) {
		uploadBoardService.removeUpload(request, response);
	}
	
	// 조회수
	@GetMapping("board/upload/incrase/hit")
	public String incraseHit(@RequestParam(value = "uploadNo", required = false, defaultValue = "0")int uploadNo) {
		int result = uploadBoardService.increaseHit(uploadNo);
		if(result > 0 ) {
			return "redirect:/board/upload/detail?uploadNo=" + uploadNo;
		} else {
			return "redirect:/board/upload/list";
		}
	}
	
}
