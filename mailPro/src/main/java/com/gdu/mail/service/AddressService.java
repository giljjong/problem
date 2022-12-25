package com.gdu.mail.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AddressService {
	public Map<String, Object> getDeptList();
	public Map<String, Object> getMyGroupList(HttpServletRequest request);
}
