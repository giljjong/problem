package com.group.sharegram.board.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group.sharegram.board.domain.AnonyCommentDTO;
import com.group.sharegram.board.mapper.AnonyCommentMapper;
import com.group.sharegram.board.util.BoardPageUtil;
import com.group.sharegram.user.domain.EmployeesDTO;

@Service
public class AnonyCommentServiceImpl implements AnonyCommentService {
	
	@Autowired
	private AnonyCommentMapper commentMapper;
	
	@Autowired
	private BoardPageUtil pageUtil;
	
	@Override
	public Map<String, Object> getCommentCount(int anonyNo) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("commentCount", commentMapper.selectCommentCount(anonyNo));
		return result;
	}
	
	@Override
	public Map<String, Object> addComment(HttpServletRequest request) {
		
		String content = request.getParameter("content");
		int anonyNo = Integer.parseInt(request.getParameter("anonyNo"));
		int empNo = Integer.parseInt(request.getParameter("empNo"));
		
		AnonyCommentDTO comment = AnonyCommentDTO.builder()
				.content(content)
				.anonyNo(anonyNo)
				.user(EmployeesDTO.builder().empNo(empNo).build())
				.build();
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isAdd", commentMapper.insertComment(comment) == 1);
		return result;
		
	}
	
	@Override
	public Map<String, Object> getCommentList(HttpServletRequest request) {
		
		int anonyNo = Integer.parseInt(request.getParameter("anonyNo"));
		int page = Integer.parseInt(request.getParameter("page"));
		int totalRecord = 10;
		
		int commentCount = commentMapper.selectCommentCount(anonyNo);
		pageUtil.setPageUtil(page, commentCount, totalRecord);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("anonyNo", anonyNo);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("commentList", commentMapper.selectCommentList(map));
		result.put("pageUtil", pageUtil);
		
		return result;
		
	}
	
	@Override
	public Map<String, Object> removeComment(int commentNo) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isRemove", commentMapper.deleteComment(commentNo) == 1);
		return result;
	}
	
	@Override
	public Map<String, Object> addReply(HttpServletRequest request) {
		
		String content = request.getParameter("content");
		int anonyNo = Integer.parseInt(request.getParameter("anonyNo"));
		int groupNo = Integer.parseInt(request.getParameter("groupNo"));		
		int empNo = Integer.parseInt(request.getParameter("empNo"));
		
		AnonyCommentDTO reply = AnonyCommentDTO.builder()
				.content(content)
				.anonyNo(anonyNo)
				.groupNo(groupNo)
				.user(EmployeesDTO.builder().empNo(empNo).build())
				.build();
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isAdd", commentMapper.insertReply(reply) == 1);
		return result;
		
	}
	
	
	
}