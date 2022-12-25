package com.gdu.mail.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.mail.service.AddressService;

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
		return addressService.getDeptList();
	}
	
}
