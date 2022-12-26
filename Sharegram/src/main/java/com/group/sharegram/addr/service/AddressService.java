package com.group.sharegram.addr.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AddressService {
	public Map<String, Object> getDeptList();
	public Map<String, Object> getMyGroupList(HttpServletRequest request);
	public Map<String, Object> getStarList(HttpServletRequest request);
	public Map<String, Object> getEmpListByDept(HttpServletRequest request);
	public Map<String, Object> getEmpAddrByEmpNo(HttpServletRequest request);
	public Map<String, Object> addAddressGroup(HttpServletRequest request);
}
