package com.group.sharegram2.addr.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.group.sharegram2.addr.domain.EmpAddrDTO;
import com.group.sharegram2.addr.domain.EmployeesDTO;
import com.group.sharegram2.mail.util.SecurityUtil;
import com.group.sharegram2.mapper.AddressMapper;
import com.group.sharegram2.mapper.EmpMapper;
import com.group.sharegram2.mapper.MailMapper;

@Service
public class EmpServiceImpl implements EmpService {

	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private MailMapper mailMapper;
	
	@Autowired
	private AddressMapper addrMapper;
	
	@Autowired
	private SecurityUtil securityUtil;

	@Transactional
	@Override
	public void join(HttpServletRequest request, HttpServletResponse response) {

		String password = request.getParameter("empPw");
		String name = request.getParameter("name");
		String birthday = request.getParameter("birthday");
		String deptName = request.getParameter("deptName");
		String jobName = request.getParameter("jobName");
		
		String empPw = securityUtil.sha256(password);
		name = securityUtil.preventXSS(name);
		
		EmployeesDTO emp = EmployeesDTO.builder()
				.empPw(empPw)
				.name(name)
				.birthday(birthday)
				.build();
		
		int result = empMapper.insertDept(deptName);
		result += empMapper.insertPosition(jobName);
		result += empMapper.insertEmp(emp);
		
		try {
			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			if(result > 2) {
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("name", name);
				map.put("empPw", empPw);
				
				EmployeesDTO loginUser =  empMapper.selectEmpByMap(map);
				request.getSession().setAttribute("loginUser", loginUser);
				
				int empNo = loginUser.getEmpNo();
				String email = empNo + "@sharegram.com";
				
				EmpAddrDTO empInfo = EmpAddrDTO.builder()
						.empNo(empNo)
						.name(name)
						.email(email)
						.password(password)
						.build();
				
				int mailResult = mailMapper.insertJamesUser(empInfo);
				mailResult += addrMapper.insertEmpAddr(empInfo);
				mailResult += addrMapper.insertUnspecifiedGroup(empNo);
				
				if(mailResult > 2) {
					request.getSession().setAttribute("mailUser", empInfo);
				}
				
				out.println("<script>");
				out.println("alert('회원 가입 되었습니다.');");
				out.println("location.href='"+ request.getContextPath() +"';");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('회원 가입이 실패하였습니다.');");
				out.println("history.go(-1);");
				out.println("</script>");
			}
			out.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void login(HttpServletRequest request, HttpServletResponse response) {
		Optional<String> opt = Optional.of(request.getParameter("empNo"));
		int empNo = Integer.parseInt(opt.orElse("0"));
		String empPw = request.getParameter("empPw");

		empPw = securityUtil.sha256(empPw);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("empPw", empPw);
	
		EmployeesDTO loginUser = empMapper.selectEmpByMap(map);

		if(loginUser != null) {
			
			request.getSession().setAttribute("loginUser", loginUser);
			
			EmpAddrDTO mailUser = addrMapper.selectEmpAddrByNo(empNo);
			
			if(mailUser != null) {
				request.getSession().setAttribute("mailUser", mailUser);
			}

			try {
				response.sendRedirect(request.getContextPath() + "/mail/folder/list");
			} catch(IOException e) {
				e.printStackTrace();
			}
			
		} else {

			try {
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				
				out.println("<script>");
				out.println("alert('일치하는 회원 정보가 없습니다.');");
				out.println("location.href='" + request.getContextPath() + "';");
				out.println("</script>");
				out.close();
				
			} catch(Exception e) {
				e.printStackTrace();
			}
			
		}
	}
	
}
