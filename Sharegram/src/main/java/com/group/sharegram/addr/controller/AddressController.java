package com.group.sharegram.addr.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.addr.service.AddressService;

@Controller
public class AddressController {
	
	@Autowired
	private AddressService addressService;

	@GetMapping("/addr/addressList")
	public String addrList() {
		return "addr/addressList";
	}
	
	@ResponseBody
	@GetMapping("/add/depList")
	public Map<String, Object> getDeptList() {
		return addressService.getDeptList();
	}
	
	@ResponseBody
	@GetMapping("/add/myGroup/List")
	public Map<String, Object> getMyGroupList(HttpServletRequest request) {
		return addressService.getMyGroupList(request);
	}
	
	@ResponseBody
	@PostMapping("/add/starList")
	public Map<String, Object> getStarListPerPage(HttpServletRequest request) {
		return addressService.getStarList(request);
	}
	
	@ResponseBody
	@PostMapping("/get/dept/empList")
	public Map<String, Object> getEmpList(HttpServletRequest request) {
		return addressService.getEmpListByDept(request);
	}
	
	@ResponseBody
	@PostMapping("/get/emp/detail")
	public Map<String, Object> getDetailEmp(HttpServletRequest request) {
		return addressService.getEmpAddrByEmpNo(request);
	}
	
	@ResponseBody
	@GetMapping("/add/addr/group")
	public Map<String, Object> AddrGroupAdd(HttpServletRequest request) {
		return addressService.getEmpAddrByEmpNo(request);
	}
	
}
