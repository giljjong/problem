package com.gdu.mail.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.gdu.mail.service.EmpService;

@Controller
public class EmpController {
	
	@Autowired
	private EmpService empService;
	
	@GetMapping("/emp/join/write")
	public String join() {
		return "emp/join";
	}
	
	@PostMapping("/emp/join")
	public void join(HttpServletRequest request, HttpServletResponse response) {
		empService.join(request, response);
	}
	
	@PostMapping("/emp/login")
	public void login(HttpServletRequest request, HttpServletResponse response) {
		empService.login(request, response);
	}
	
}
