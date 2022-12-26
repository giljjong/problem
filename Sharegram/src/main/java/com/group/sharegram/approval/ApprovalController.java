package com.group.sharegram.approval;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.group.sharegram.company.CompanyService;
import com.group.sharegram.user.DTO.CustomUserDetails;


@Controller
@RequestMapping("/approval")
public class ApprovalController {
	
	@Autowired
	ApprovalService ApproService;
	@Autowired
	CompanyService companyService;
	
	public static final int LIMIT = 10;
	

	@RequestMapping(value = "/driftlist", method = RequestMethod.GET, produces = "application/text; charset=utf8")
	public ModelAndView approvalService(ModelAndView mv,
			@RequestParam(name = "page", defaultValue = "1") int page,
			Authentication authentication) {
		try {
			int currentPage = page;
			int listCount = ApproService.listCount();
			int maxPage = (int) ((double) listCount / LIMIT + 0.9);
			//세션값
			CustomUserDetails userdetail = (CustomUserDetails) authentication.getPrincipal();
			String uno=userdetail.getUno();
		    
//			System.out.println("뭘까유" + ApproService.selectList());
			
			mv.addObject("list", ApproService.selectList(currentPage,LIMIT,uno));
			mv.addObject("currentPage", currentPage);
			mv.addObject("maxPage", maxPage);
			mv.addObject("listCount", listCount);
			System.out.println(ApproService.selectList(currentPage,LIMIT,uno));
			mv.setViewName("approval/driftlist");
		
//			int listCount = ApproService.totalCount();
//			mv.addObject("listCount", listCount);
			
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}

		return mv;
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET, produces = "application/text; charset=utf8")
	public ModelAndView aapprovalService(ModelAndView mv,
			@RequestParam(name = "page", defaultValue = "1") int page, HttpServletRequest request) {
		try {
			int currentPage = page;
			int listCount = ApproService.listCount();
			int maxPage = (int) ((double) listCount / LIMIT + 0.9);
			//세션값
			CustomUserDetails userdetail = (CustomUserDetails)request.getSession().getAttribute("loginUser");  // authentication.getPrincipal();
			String uno=userdetail.getUno();
		    
//			System.out.println("뭘까유" + ApproService.selectList()); 
			
			mv.addObject("list", ApproService.selectList(currentPage,LIMIT,uno));
			mv.addObject("currentPage", currentPage);
			mv.addObject("maxPage", maxPage);
			mv.addObject("listCount", listCount);
			System.out.println(ApproService.selectList(currentPage,LIMIT,uno));
			mv.setViewName("approval/list");
		
//			int listCount = ApproService.totalCount();
//			mv.addObject("listCount", listCount);
			
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}

		return mv;
	}
	
	
	
	@RequestMapping(value = "/drift", method = RequestMethod.GET, produces = "application/text; charset=utf8")
	public ModelAndView approvalDetail(ModelAndView mv,
			@RequestParam(name = "apNo") String apNo,
			@RequestParam(name = "page", defaultValue = "1") int page,
			Authentication authentication) {

		try {
			int currentPage = page;
			// 한 페이지당 출력할 목록 갯수
			mv.addObject("apno", ApproService.selectOne(0, apNo));
			System.out.println("게시판 내용"+ApproService.selectOne(0, apNo));
			mv.addObject("currentPage", currentPage);
			mv.setViewName("approval/drift");

		} catch (Exception e) {
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}
		return mv;
		
	}
	
	@RequestMapping(value = "/driftform" , method = RequestMethod.GET)
	public ModelAndView driftform(Authentication authentication,ModelAndView mv) {
		CustomUserDetails userdetail = (CustomUserDetails) authentication.getPrincipal();
		String cno=userdetail.getCno();
		String ceo = null;
		try {
			ceo = companyService.SelectCEO(cno);	
			System.out.println("ceo이름"+ceo);
			
			//dept name뿌리는거 가져와야함. 추후 수정 예정. 
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("ceo", ceo);
		mv.setViewName("approval/driftform");
		return mv;
	}
	
	//결재완료 업데이트
	@RequestMapping(value = "/stateupdate" , method = RequestMethod.GET)
	public ModelAndView stateupdate(ModelAndView mv, 
			 ApprovalDTO dto) {
		
		try {
		mv.addObject("apno", ApproService.stateupdate(dto).getApNo());
		mv.setViewName("redirect:driftlist");
		
		}catch (Exception e) {
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}
		return mv;
	}
	//반려사유 업데이트
	
	@RequestMapping(value = "/updateaprejection" , method = RequestMethod.GET)
	public ModelAndView updateaprejection(ModelAndView mv, 
			 ApprovalDTO dto) {
		try {
		mv.addObject("aprejection", ApproService.updateaprejection(dto).getApNo());
		mv.setViewName("redirect:driftlist");
		}catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}
		return mv;
	}
	
	
	//기안작성
	@RequestMapping(value = "/appinsert", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public ModelAndView insertApproval(ApprovalDTO dto, @RequestParam(required = false) HttpServletRequest request,
			ModelAndView mv) throws Exception {
		try {
			System.out.println("insert들어옴");
			ApproService.insertApproval(dto);
			mv.setViewName("redirect:driftlist");
			
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg", e.getMessage());
			mv.setViewName("errorPage");
		}
		return mv;
	}
	
	
	

}
