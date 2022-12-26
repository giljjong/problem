package com.group.sharegram.board.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.domain.AnonyBoardDTO;
import com.group.sharegram.board.mapper.AnonyBoardMapper;
import com.group.sharegram.board.util.BoardPageUtil;
import com.group.sharegram.board.util.BoardSecurityUtil;

@Service
public class AnonyBoardServiceImpl implements AnonyBoardService {
	
	@Autowired
	private AnonyBoardMapper anonyBoardMapper;
	
	@Autowired
	private BoardPageUtil pageUtil;
	
	@Autowired
	private BoardSecurityUtil securityUtil;
	
	@Override
	public void findAllAnonyList(HttpServletRequest request, Model model) {
		
		Optional<String> opt1 = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt1.orElse("1"));
		
		Optional<String> opt2 = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(opt2.orElse("5"));

		// 전체 게시글 개수
		int totalRecord = anonyBoardMapper.selectAllAnonyListCount();
		
		// 페이징에 필요한 모든 계산 완료
		pageUtil.setPageUtil(page, recordPerPage, totalRecord);
		
		// DB로 보낼 Map(begin + end)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		// DB에서 목록 가져오기
		List<AnonyBoardDTO> anonyBoardList = anonyBoardMapper.selectAnonyList(map);
		
		// 뷰로 보낼 데이터
		model.addAttribute("anonyBoardList", anonyBoardList);
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "/board/anonyList?recordPerPage=" + recordPerPage));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		model.addAttribute("recordPerPage", recordPerPage);
		
	}
	
	@Override
	public void save(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		
//		int empNo = Integer.parseInt(multipartRequest.getParameter("empNo"));   // 우선 임의 empNo값 사용
		String title = securityUtil.preventXSS(multipartRequest.getParameter("anonyTitle"));	// 코드 타입 chk(board내 통일 유무)
		String content = securityUtil.preventXSS(multipartRequest.getParameter("anonyContent"));
		
		
		AnonyBoardDTO anony = AnonyBoardDTO.builder()
				.anonyTitle(title)
				.anonyContent(content)
				.empNo(22120002)
				.build();
				
		// DB 저장
		int anonyResult = anonyBoardMapper.insertAnony(anony);
		
		// 응답
		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			 out.println("<script>");
			 if(anonyResult > 0) {
					
				} else {
					//out.println("<script>");
					out.println("alert('게시글 등록에 실패했습니다.');");
					out.println("history.back();");
					}
				out.println("</script>");
				out.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
	
	@Override
	public AnonyBoardDTO getAnonyByNo(int anonyNo) {
		return anonyBoardMapper.selectAnonyByNo(anonyNo);
	}
	
	@Override
	public int removeAnony(int anonyNo) {
		return anonyBoardMapper.deleteAnony(anonyNo);
	}
	
	
	@Override
	public void findAnony(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("anonyNo"));
		int anonyNo = Integer.parseInt(opt.orElse("0"));
		
		AnonyBoardDTO anony = anonyBoardMapper.selectAnonyByNo(anonyNo);
		model.addAttribute("AnonyBoard", anony);
	}
	

	/*
	 * @Override public int increaseHit(int noticNo) { return
	 * anonyBoardMapper.updateHit(noticNo); }
	 */
	
	
	
}