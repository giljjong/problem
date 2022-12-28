package com.group.sharegram.user.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.group.sharegram.addr.domain.EmpAddrDTO;
import com.group.sharegram.addr.mapper.AddressMapper;
import com.group.sharegram.mail.mapper.MailMapper;
import com.group.sharegram.user.domain.EmployeesDTO;
import com.group.sharegram.user.domain.RetiredDTO;
import com.group.sharegram.user.mapper.EmpMapper;
import com.group.sharegram.user.util.UserPageUtil;
import com.group.sharegram.user.util.UserSecurityUtil;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;



@Service
public class EmpServiceImpl implements EmpService {
	
	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private UserSecurityUtil securityUtil;
	
	@Autowired
	private UserPageUtil pageUtil;
	
	@Autowired
	private AddressMapper addrMapper;
	
	@Autowired
	private MailMapper mailMapper;
	
	
	@Override
	public Map<String, Object> isReduceEmpNo(int empNo) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		
		Map<String, Object> result =new HashMap<String, Object>();
		
		result.put("isEmp", empMapper.selectEmpByMap(map) != null);
		result.put("isRetireEmp", empMapper.selectRetireEmpByNo(empNo) != null );
		
		return result;
		
	}
	
	
	
	
	@Transactional		// 추가
	@Override
	public void join(HttpServletRequest request, HttpServletResponse response) {
		
		// 파라미터
		String password=request.getParameter("empPw");	// 수정
		String name=request.getParameter("name");
		String phone=request.getParameter("phone");
		String birthyear=request.getParameter("birthyear");
		String birthmonth = request.getParameter("birthmonth");
		String birthdate = request.getParameter("birthdate");
//		String profImg=request.getParameter("profImg");
		String status=request.getParameter("status");
		int salary=Integer.parseInt(request.getParameter("salary"));
//		int jobNo=Integer.parseInt(request.getParameter("jobNo"));
//		int deptNo=Integer.parseInt(request.getParameter("deptNo"));
		
		System.out.println(request.getParameter("empPw"));
		System.out.println(request.getParameter("name"));
		System.out.println(request.getParameter("phone"));
		System.out.println(request.getParameter("birthyear"));
		System.out.println(request.getParameter("birthmonth"));
		System.out.println(request.getParameter("birthdate"));
		
		
		String empPw=securityUtil.sha256(password);	// 수정
//		name=securityUtil.preventXSS(name);
		String birthday= birthmonth + birthdate;
		
		// DB로 보내기
		EmployeesDTO emp = EmployeesDTO.builder()
//						.empNo(empNo)
						.empPw(empPw)
						.name(name)
						.phone(phone)
						.birthyear(birthyear)
						.birthday(birthday)
//						.profImg(profImg)
						.status(status)
						.salary(salary)
						.jobNo(4)
						.deptNo(11)
						.build();
		
		System.out.println("전 : " + emp);	
		
		
		// 유저 등록 처리
		int result=empMapper.insertEmp(emp);	
		System.out.println("후 : " + emp);
		
		// 응답
		
		try {
			response.setContentType("text/html; charset=UTF-8");	// 전체 수정
			PrintWriter out = response.getWriter();
			
			if(result > 0) {
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("name", name);
				map.put("empPw", empPw);
				
				int empNo = emp.getEmpNo();
				System.out.println(empNo);
				String email = empNo + "@sharegram.com";
				System.out.println(email);
				System.out.println(password);
				
				EmpAddrDTO empInfo = EmpAddrDTO.builder()
						.empNo(empNo)
						.name(name)
						.email(email)
						.password(password)
						.phone(phone)
						.deptNo(emp.getDeptNo())
						.jobNo(emp.getJobNo())
						.build();
				
				int mailResult = mailMapper.insertJamesUser(empInfo);
				mailResult += addrMapper.insertEmpAddr(empInfo);
				mailResult += addrMapper.insertUnspecifiedGroup(empNo);
				
				out.println("<script>");
				out.println("alert('등록 되었습니다.');");
				out.println("location.href='"+ request.getContextPath() +"/user/list';");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('등록 되지않았습니다.');");
				out.println("histroy.back();");
				out.println("</script>");
				
			}
			
			out.close();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	@Override
	public void retire(HttpServletRequest request, HttpServletResponse response) {
		
	
		
	}
		

	


	
	@Override
	public void login(HttpServletRequest request, HttpServletResponse response) {
		
		// 파라미터
		int empNo=Integer.parseInt(request.getParameter("empNo"));
		String empPw=request.getParameter("empPw");
		
		empPw=securityUtil.sha256(empPw);
		
		// 조회 조건으로 사용할 Map
		Map<String, Object> map= new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("empPw", empPw);
		
		// No,Pw가 일치하는 회원 DB에서 조회
		EmployeesDTO loginEmp= empMapper.selectEmpByMap(map);
		
		// No, pw가 일치하는 회원이 있다 : session에 loginUser 저장하기 + 로그인 기록 남기기 
		if(loginEmp != null) {
			
			// 로그인 처리를 위해서 session에 로그인 된 사용자 정보를 올려둠
			request.getSession().setAttribute("loginEmp", loginEmp);
			System.out.println("loginEmp 동작 세션에" + loginEmp);
			
			EmpAddrDTO mailUser = addrMapper.selectEmpAddrByNo(empNo);	// 수정
			
			if(mailUser != null) {
				mailUser.setPassword("");
				request.getSession().setAttribute("mailUser", mailUser);
			}
			
			// 이동
			try {
				response.sendRedirect(request.getContextPath());
			} catch(IOException e) {
				e.printStackTrace();
			}
			
		} else {
			
			// 응답
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


	@Override
	public void logout(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session =request.getSession();
		if(session.getAttribute("loginEmp")!= null) {
			session.invalidate();
		}
		
	}


	// 직원: 마이페이지 들어가기 전 비밀번호 확인
	@Override
	public Map<String, Object> confirmPw(HttpServletRequest request) {
		
		String empPw=securityUtil.sha256(request.getParameter("empPw"));
		
		HttpSession session=request.getSession();
		int empNo= ((EmployeesDTO) session.getAttribute("loginEmp")).getEmpNo();

		
		// 조회 조건으로 사용할 Map
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("empPw", empPw);
		
		
		// No,Pw가 일치하는 직원을 찾는다
		EmployeesDTO emp = empMapper.selectEmpByMap(map);
		
		// 결과 반환
		Map<String, Object>result =new HashMap<String, Object>();
		result.put("isEmp", emp != null);
		
		return result;
	}
	
	
	
	
	
	
	@Override
	public void modifyMyPassword(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session =request.getSession();
		EmployeesDTO loginEmp= (EmployeesDTO)session.getAttribute("loginEmp");
		System.out.println("loginEmp");
		System.out.println(loginEmp);
		
		// 파라미터
		String empPw=securityUtil.sha256(request.getParameter("empPw"));
		System.out.println("----");
		System.out.println(empPw);
		// 동일한 비밀번호로 변경 금지
		if(empPw.equals(loginEmp.getEmpPw())) {
			
			// 응답
			try {
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				
				out.println("<script>");
				out.println("alert('현재 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.');");
				out.println("history.back();");
				out.println("</script>");
				out.close();
				
			} catch(Exception e) {
				e.printStackTrace();
			}

		}
		
		
		// 사용자 아이디
		int empNo =loginEmp.getEmpNo();
		System.out.println("empNo");
		System.out.println(empNo);
		EmployeesDTO emp = EmployeesDTO.builder()
				.empNo(empNo)
				.empPw(empPw)
				.build();
		
		
		// 비밀번호 수정
		int result = empMapper.updateMyPassword(emp);
		
		
		// 응답
		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out =response.getWriter();
			
			if(result > 0) {
				
				loginEmp.setEmpPw(empPw);
				
				out.println("<script>");
				out.println("alert('비밀번호가 수정되었습니다.');");
				out.println("location.href='" + request.getContextPath() + "';");
				out.println("</script>");
				
			}else {
				out.println("<script>");
				out.println("alert('비밀번호가 수정되지 않았습니다.');");
				out.println("history.back();");
				out.println("</script>");
				
			}
			out.close();			
			}catch(Exception e) {
				e.printStackTrace();
			}
		
	}
	
	
	// 널값 떨어짐 물어보자
	@Override
	public void modifyMyinfo(HttpServletRequest request, HttpServletResponse response) {
		
		
		HttpSession session = request.getSession();
		EmployeesDTO loginEmp=(EmployeesDTO)session.getAttribute("loginEmp");
		
		
		// 파라미터
		
		String empPw =securityUtil.sha256(request.getParameter("empPw"));
		String phone=request.getParameter("phone");
//		String profImg=request.getParameter("profImg");
		String status=request.getParameter("status");
		
		
		// 사용자 번호
		int empNo= loginEmp.getEmpNo();
		
		EmployeesDTO emp = EmployeesDTO.builder()
				.empNo(empNo)
				.empPw(empPw)
				.phone(phone)
				.status(status)
//				.profImg(profImg)
				.build();
		
		

		
	 // 정보 변경 안됨 ㅡㅡ
		int result = empMapper.updateMyinfo(emp);

	
	
	
	// 응답
	try {
		
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out =response.getWriter();
		
		
		if(result > 0) {
			loginEmp.setPhone(phone);
			loginEmp.setStatus(status);
//			loginEmp.setProfImg(profImg);
			
			out.println("<script>");
			out.println("alert('회원정보가 수정되었습니다.');");
			out.println("location.href='" + request.getContextPath() + "';");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('회원정보가 수정되지 않았습니다.');");
			out.println("history.back();");
			out.println("</script>");
			
		}
		out.close();
	} catch(Exception e) {
		e.printStackTrace();
	}
		
		
	}
	
	
	@Override
	public void findAllEmp(HttpServletRequest request, Model model) {
		Optional<String> opt=Optional.ofNullable(request.getParameter("page"));
		int page=Integer.parseInt(opt.orElse("1"));
		
		int totalRecord=empMapper.selectAllEmpListCnt();
		
		// 페이지 계산
		pageUtil.setPageUtil(page, totalRecord);
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin() - 1);
		map.put("recordPerPage", pageUtil.getRecordPerPage());
		
		
		// begin end 목록 가져오기
		List<EmployeesDTO> emp= empMapper.selectEmpByPage(map);
		
		
		model.addAttribute("emp", emp); // "emp"라는 이름으로 list.jsp로 넘어감
		model.addAttribute("paging",pageUtil.getPaging(request.getContextPath()+ "/user/list"));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		
		System.out.println("emp:"+emp);
		
		
		
	}
	
	
	
	
	
	
	

	
	

	
	
	
	
	
}
	
	
	
	
	
	
	
	
	
	
	
	


