package com.gdu.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.EmployeesDTO;
import com.gdu.mail.domain.PersonalAddrDTO;
import com.gdu.mail.mapper.AddressMapper;
import com.gdu.mail.util.PageUtil;

@Service
public class AddressServiceImpl implements AddressService {
	
	@Autowired
	private AddressMapper addressMapper;
	
	@Autowired
	private PageUtil pageUtil;

	@Override
	public Map<String, Object> getDeptList() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptList", addressMapper.selectDeptList());
		return map;
	}
	
	@Override
	public Map<String, Object> getMyGroupList(HttpServletRequest request) {
		EmployeesDTO loginUser = (EmployeesDTO) request.getSession().getAttribute("loginUser");
		int empNo = loginUser.getEmpNo();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("myGroupList", addressMapper.selectMyAddrGroupList(empNo));
		return map;
	}
	
	@Override
	public Map<String, Object> getStarList(HttpServletRequest request) {
		EmployeesDTO loginUser = (EmployeesDTO) request.getSession().getAttribute("loginUser");
		int empNo = loginUser.getEmpNo();
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int recordPerPage = 5;
		
		int totalRecord = addressMapper.selectImportantPersonalAddrCnt(empNo);
		
		
		pageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("begin", pageUtil.getBegin());
		int end = pageUtil.getEnd();
		if(pageUtil.getEnd() == 0) {
			end = 1;
		}
		map.put("end", end);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("starList", addressMapper.selectImportantPersonalAddr(map));
		result.put("pageUtil", pageUtil);
		return result;
	}

}
