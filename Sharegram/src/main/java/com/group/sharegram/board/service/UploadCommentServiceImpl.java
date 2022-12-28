package com.group.sharegram.board.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group.sharegram.board.domain.UploadCommentDTO;
import com.group.sharegram.board.mapper.UploadCommentMapper;
import com.group.sharegram.board.util.BoardPageUtil;


@Service
public class UploadCommentServiceImpl implements UploadCommentService {
	
	
	 
	@Autowired
	private UploadCommentMapper uploadCommentMapper;
	
	@Autowired
	private BoardPageUtil pageUtil;
	
	@Override
	public Map<String, Object> getUploadCommentCount(int anonyNo){
		Map<String, Object> result=new HashMap<String, Object>();
		result.put("commentCount", uploadCommentMapper.selectCommentCount(anonyNo));
		return result;
	}

	@Override
	public Map<String, Object> addUploadComment(UploadCommentDTO comment, HttpServletRequest request) {
		int empNo = Integer.parseInt(request.getParameter("empNo"));
        comment.setEmpNo(empNo);
		Map<String, Object> result=new HashMap<String, Object>();
		result.put("isAdd", uploadCommentMapper.insertComment(comment)==1);
		return result;
		
	}
	
	
	@Override
	public Map<String, Object> getUploadCommentList(HttpServletRequest request) {
		
		int anonyNo =Integer.parseInt(request.getParameter("anonyNo"));
		int page=Integer.parseInt(request.getParameter("page"));
		int totalRecord = 10;
		
		int commentCount=uploadCommentMapper.selectCommentCount(anonyNo);
		pageUtil.setPageUtil(page, commentCount, totalRecord);
		
		Map<String, Object> map= new HashMap<String, Object>();
		map.put("anonyNo", anonyNo);
		map.put("begin", pageUtil.getBegin() - 1);
		map.put("recordPerPage", pageUtil.getRecordPerPage());
		
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("commentList", uploadCommentMapper.selectCommentList(map));
		System.out.println(uploadCommentMapper.selectCommentList(map));
		result.put("pageUtil", pageUtil);
		
		return result;
	}
	
	
	@Override
	public Map<String, Object> removeUploadComment(int commentNo) {
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("isRemove", uploadCommentMapper.deleteComment(commentNo)==1);
		return result;
	}
	
	
	@Override
	public Map<String, Object> addUploadReply(UploadCommentDTO reply, HttpServletRequest request) {
		int empNo = Integer.parseInt(request.getParameter("empNo"));  
        reply.setEmpNo(empNo);
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("isAdd", uploadCommentMapper.insertReply(reply)==1);
		return result;
	}
	
	
}
	
	
