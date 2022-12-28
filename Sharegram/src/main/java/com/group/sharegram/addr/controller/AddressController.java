package com.group.sharegram.addr.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.domain.PersonalAddrDTO;
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
		return addressService.addAddressGroup(request);
	}
	
	@PostMapping("/add/personal/addr")
	public String addAddress(PersonalAddrDTO pAddr, HttpServletResponse response) {
		return addressService.addPersonalAddr(pAddr, response);
	}
	
	@ResponseBody
	@PostMapping("/detail/myAddr/list")
	public Map<String, Object> getMyAddrDetail(HttpServletRequest request) {
		return addressService.getMyAddressInChoiceGroup(request);
	}
	
	@ResponseBody
	@PostMapping("/delete/checked/myAddr")
	public Map<String, Object> deletecheckedMyAddr(@RequestParam("personalNo[]") List<String> personalNo) {
		return addressService.removeCheckedPersonal(personalNo);
	}
	
	@ResponseBody
	@PostMapping("/my/addr/detail")
	public Map<String, Object> choiceAddrDetail(@RequestParam("personalNo") int personalNo) {
		return addressService.getPersonalDetail(personalNo);
	}
	
	@ResponseBody
	@PostMapping("/change/important")
	public Map<String, Object> changeImportantCheck(PersonalAddrDTO person) {
		return addressService.setImportantCheck(person);
	}
	
	@ResponseBody
	@GetMapping("/modify/group")
	public Map<String, Object> modifyGroup(AddrGroupDTO group) {
		return addressService.modifyAddrGroupName(group);
	}
	
	@ResponseBody
	@PostMapping("/delete/myAddr")
	public Map<String, Object> deleteMyAddr(@RequestParam("personalNo[]") List<String> personalNo) {
		return addressService.removeCheckedPersonal(personalNo);
	}
	
	@ResponseBody
	@PostMapping("/remove/group")
	public Map<String, Object> deleteGroup(@RequestParam("addrGroupNo") int addrGroupNo) {
		return addressService.removeAddrGroup(addrGroupNo);
	}
}
