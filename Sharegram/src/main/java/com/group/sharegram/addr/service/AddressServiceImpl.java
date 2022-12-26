package com.group.sharegram.addr.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.mapper.AddressMapper;
import com.group.sharegram.user.domain.EmployeesDTO;
import com.group.sharegram.mail.util.MailPageUtil;

@Service
public class AddressServiceImpl implements AddressService {
	
	@Autowired
	private AddressMapper addressMapper;
	
	@Autowired
	private MailPageUtil mailPageUtil;

	@Override
	public Map<String, Object> getDeptList() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptList", addressMapper.selectDeptList());
		return map;
	}
	
	@Override
	public Map<String, Object> getMyGroupList(HttpServletRequest request) {
		EmployeesDTO loginEmp = (EmployeesDTO) request.getSession().getAttribute("loginEmp");
		int empNo = loginEmp.getEmpNo();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("myGroupList", addressMapper.selectMyAddrGroupList(empNo));
		return map;
	}
	
	@Override
	public Map<String, Object> getStarList(HttpServletRequest request) {
		EmployeesDTO loginEmp = (EmployeesDTO) request.getSession().getAttribute("loginEmp");
		int empNo = loginEmp.getEmpNo();
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int recordPerPage = 5;
		
		int totalRecord = addressMapper.selectImportantPersonalAddrCnt(empNo);
		
		mailPageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("begin", mailPageUtil.getBegin());
		int end = mailPageUtil.getEnd();
		if(mailPageUtil.getEnd() == 0) {
			end = 1;
		}
		map.put("end", end);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("starList", addressMapper.selectImportantPersonalAddr(map));
		result.put("pageUtil", mailPageUtil);
		return result;
	}

	@Override
	public Map<String, Object> getEmpListByDept(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("deptNo"));
		int deptNo = Integer.parseInt(opt.orElse("0"));
		
		Optional<String> pageOpt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(pageOpt.orElse("1"));
		
		int recordPerPage = 15;
		
		int totalRecord = addressMapper.selectEmpAddrByDeptNoCnt(deptNo);
		
		mailPageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptNo", deptNo);
		map.put("begin", mailPageUtil.getBegin());
		map.put("end", mailPageUtil.getEnd());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("empAddrsList", addressMapper.selectEmpAddrListByDeptNo(map));
		result.put("pageUtil", mailPageUtil);
		
		return result;
	}
	
	@Override
	public Map<String, Object> getEmpAddrByEmpNo(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("empNo"));
		int empNo = Integer.parseInt(opt.orElse("0"));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empInfo", addressMapper.selectEmpAddrByEmpNo(empNo));
		
		return map;
	}
	
	@Override
	public Map<String, Object> addAddressGroup(HttpServletRequest request) {
		EmployeesDTO loginEmp = (EmployeesDTO) request.getSession().getAttribute("loginEmp");
		int empNo = loginEmp.getEmpNo();
		
		String addrGroupName = request.getParameter("addrGroupName");
		
		AddrGroupDTO group = AddrGroupDTO.builder()
				.empNo(empNo)
				.addrGroupName(addrGroupName)
				.build();
		
		int result = addressMapper.insertAddrGroup(group);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result = 1);
		
		return map;
	}
}
