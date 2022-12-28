package com.group.sharegram.addr.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.domain.PersonalAddrDTO;

public interface AddressService {
	public Map<String, Object> getDeptList();
	public Map<String, Object> getMyGroupList(HttpServletRequest request);
	public Map<String, Object> getStarList(HttpServletRequest request);
	public Map<String, Object> getEmpListByDept(HttpServletRequest request);
	public Map<String, Object> getEmpAddrByEmpNo(HttpServletRequest request);
	public Map<String, Object> addAddressGroup(HttpServletRequest request);
	public String addPersonalAddr(PersonalAddrDTO pAddr, HttpServletResponse response);
	public Map<String, Object> getMyAddressInChoiceGroup(HttpServletRequest request);
	public Map<String, Object> returnMap(int no, int page, int totalRecord);
	public Map<String, Object> removeCheckedPersonal(List<String> personalNo);
	public Map<String, Object> getPersonalDetail(int personalNo);
	public Map<String, Object> setImportantCheck(PersonalAddrDTO person);
	public Map<String, Object> modifyAddrGroupName(AddrGroupDTO group);
	public Map<String, Object> removeAddrGroup(int addrGroupNo);
}
