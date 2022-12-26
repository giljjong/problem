package com.group.sharegram.user.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface EmpService {

		public Map<String, Object> isReduceEmpNo(int empNo);
		public void join(HttpServletRequest request, HttpServletResponse response);
		public void retire(HttpServletRequest request, HttpServletResponse response);
		
		
		public void login(HttpServletRequest request, HttpServletResponse response);
		public void logout(HttpServletRequest request, HttpServletResponse response);
		public Map<String, Object> confirmPw(HttpServletRequest request); // 비밀번호 확인
		
		// 마이페이지: 비밀번호 변경, 정보 수정
		public void modifyMyPassword(HttpServletRequest request, HttpServletResponse response); 
		public void modifyMyinfo(HttpServletRequest request, HttpServletResponse response);
		
		// 리스트
		public void findAllEmp(HttpServletRequest request, Model model);
		
		
		
	
	
	
	
}
