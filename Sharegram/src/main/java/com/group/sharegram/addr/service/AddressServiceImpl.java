package com.group.sharegram.addr.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.domain.EmpAddrDTO;
import com.group.sharegram.addr.domain.PersonalAddrDTO;
import com.group.sharegram.addr.mapper.AddressMapper;
import com.group.sharegram.mail.util.MailPageUtil;
import com.group.sharegram.user.domain.EmployeesDTO;

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
		
		int totalRecord = addressMapper.selectImportantPersonalAddrCnt(empNo);
		
		Map<String, Object> map = returnMap(empNo, page, totalRecord);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("starList", addressMapper.selectImportantPersonalAddr(map));
		result.put("pageUtil", mailPageUtil);
		return result;
	}

	@Override
	public Map<String, Object> getEmpListByDept(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("deptNo"));
		int deptNo = Integer.parseInt(opt.orElse("0"));
		
		System.out.println(deptNo);
		
		Optional<String> pageOpt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(pageOpt.orElse("1"));
		
		int totalRecord = addressMapper.selectEmpAddrByDeptNoCnt(deptNo);
		
		Map<String, Object> map = returnMap(deptNo, page, totalRecord);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("empAddrsList", addressMapper.selectEmpAddrListByDeptNo(map));
		result.put("pageUtil", mailPageUtil);
		
		List<EmpAddrDTO> addrs = addressMapper.selectEmpAddrListByDeptNo(map);
		for(EmpAddrDTO addr : addrs) {
			System.out.println(addr.toString());
		}
		
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
		map.put("result", result == 1);
		
		return map;
	}
	
	@Override
	public String addPersonalAddr(PersonalAddrDTO pAddr, HttpServletResponse response) {
		String directUri = "redirect:/addr/addressList";
		if(pAddr.getImportantCheck() == null) {
			pAddr.setImportantCheck("N");
		}
		
		int result =addressMapper.insertPersonalAddr(pAddr);

		try {
			if(result < 1) {
				response.setContentType("text/html; charset=UTF-8");	// 전체 수정
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('등록 되지않았습니다.');");
				out.println("</script>");
				out.close();
			}
			return directUri;
		} catch (IOException e) {
			e.printStackTrace();
			return directUri;
		}
		
	}
	
	@Override
	public Map<String, Object> getMyAddressInChoiceGroup(HttpServletRequest request) {
		Optional<String> opt1 = Optional.ofNullable(request.getParameter("addrGroupNo"));
		int addrGroupNo = Integer.parseInt(opt1.orElse("0"));
		
		Optional<String> opt2 = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt2.orElse("1"));
		
		int totalRecord = addressMapper.selectPersonalAddrListInGroupCnt(addrGroupNo);
		
		Map<String, Object> map = returnMap(addrGroupNo, page, totalRecord);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("addrList", addressMapper.selectPersonalAddrListInGroup(map));
		result.put("pageUtil", mailPageUtil);
		return result;

	}
	
	@Override
	public Map<String, Object> returnMap(int no, int page, int totalRecord) {
		
		int recordPerPage = 15;
		
		mailPageUtil.setPageUtil(page, totalRecord, recordPerPage);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("choiceNo", no);
		map.put("begin", mailPageUtil.getBegin() - 1);
		map.put("recordPerPage", mailPageUtil.getRecordPerPage());
		
		return map;
	}
	
	@Override
	public Map<String, Object> removeCheckedPersonal(List<String> personalNo) {
		int deleteResult = 0;
		for(int i = 0; i < personalNo.size(); i++) {
			int pNo = Integer.parseInt(personalNo.get(i));
			deleteResult += addressMapper.deletePersonalAddr(pNo);
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", deleteResult == personalNo.size());
		
		return result;
	}
	
	@Override
	public Map<String, Object> getPersonalDetail(int personalNo) {
		if(personalNo == 0) {
			return null;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("addr", addressMapper.selectPersonalAddr(personalNo));
		return map;
	}
	
	@Override
	public Map<String, Object> setImportantCheck(PersonalAddrDTO person) {
		
		int result = addressMapper.updateImportantFromPersonalAddr(person);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result == 1);
		
		return map;
	}
	
	@Override
	public Map<String, Object> modifyAddrGroupName(AddrGroupDTO group) {
		int result = addressMapper.updateAddrGroupName(group);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result == 1);
		
		return map;
	}
	
	@Override
	public Map<String, Object> removeAddrGroup(int addrGroupNo) {
		
		int result = addressMapper.deleteAddrGroup(addrGroupNo);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result == 1);
		
		return map;
	}
	
}
