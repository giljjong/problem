package com.gdu.mail.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.mail.domain.EmployeesDTO;
import com.gdu.mail.mapper.AddressMapper;

@Service
public class AddressServiceImpl implements AddressService {
	
	@Autowired
	private AddressMapper addressMapper;

	@Override
	public Map<String, Object> getDeptList() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptList", addressMapper.selectDeptList());
		return map;
	}
	
	@Override
	public Map<String, Object> getMyGroupList(HttpServletRequest request) {
		EmployeesDTO loginUser = (EmployeesDTO) request.getAttribute("loginUser");
		int empNo = loginUser.getEmpNo();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("myGroupList", addressMapper.selectMyAddrGroupList(empNo));
		return map;
	}

}
