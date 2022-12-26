package com.group.sharegram.user.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.user.service.EmpService;

@Controller
public class UserController {
	
	@Autowired
	private EmpService empService;
	
	
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	
	@GetMapping("/user/join/write")
	public String join() {
		return "user/join";
	}
	
	@PostMapping("/user/join")
	public void join(HttpServletRequest request, HttpServletResponse response) {
		empService.join(request, response);
	}
	
	
	@GetMapping("/user/login/form")
	public String loginForm(HttpServletRequest request, Model model) {
		model.addAttribute("url", request.getHeader("referer"));
		return "user/login";
	}
	
	@PostMapping("/user/login")
	public void login(HttpServletRequest request, HttpServletResponse response) {
		empService.login(request, response);
	}
	
	@GetMapping("/user/logout")
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		empService.logout(request, response);
		return"redirect:/";
	}
	
	@GetMapping("/user/check/form")
	public String requiredLogin_checkForm() {
		return "user/check";
	}
	
	@ResponseBody
	@PostMapping(value="user/check/pw", produces = "application/json")
	public Map<String, Object> requiredLogin_checkPw(HttpServletRequest request) {
		return empService.confirmPw(request);
	}
	
	@GetMapping("/user/mypage")
	public String requiredLogin_mypage() {
		return "user/mypage";
	}
	
	
	@PostMapping("/user/modify/pw")
	public void requiredLogin_modifyPw(HttpServletRequest request, HttpServletResponse response) {
		empService.modifyMyPassword(request, response);
	}
	
	@PostMapping("/user/modify/info")
	public void modifyInfo(HttpServletRequest request, HttpServletResponse response) {
		empService.modifyMyinfo(request, response);
	}
	
	
	/*
	 * @GetMapping("/user/list/paging") public String listPaging(HttpServletRequest
	 * request, Model model) { empService.empPaging(request, model); return
	 * "user/list_paging"; }
	 */
	
	
	@GetMapping("/user/list")  // 요청했으면 요청한 주소 그대로 복붙하는 게 좋다. (제일 앞에 /는 있어도, 없어도 그만)
	public String list(HttpServletRequest request, Model model) {
		empService.findAllEmp(request, model);
		return "user/list";  // 폴더이름 앞에 / 는 붙여도, 안 붙여도 노상관
	}
	
	
	
	
	
	
	
	
	
}


	

