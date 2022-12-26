package com.group.sharegram.board.service;

import java.io.File;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram.board.domain.NoticBoardDTO;
import com.group.sharegram.board.domain.SummernoteImageDTO;
import com.group.sharegram.board.mapper.NoticBoardMapper;
import com.group.sharegram.board.util.BoardMyFileUtil;
import com.group.sharegram.board.util.BoardPageUtil;
import com.group.sharegram.board.util.BoardSecurityUtil;

@Service
public class NoticBoardServiceImpl implements NoticBoardService {
	
	@Autowired
	private NoticBoardMapper noticBoardMapper;
	
	@Autowired
	private BoardMyFileUtil myFileUtil;
	
	@Autowired
	private BoardPageUtil pageUtil;
	
	@Autowired
	private BoardSecurityUtil securityUtil;
	
	@Override
	public void findAllNoticList(HttpServletRequest request, Model model) {
		
		Optional<String> opt1 = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt1.orElse("1"));
		
		Optional<String> opt2 = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(opt2.orElse("5"));

		// 전체 게시글 개수
		int totalRecord = noticBoardMapper.selectAllNoticListCount();
		
		// 페이징에 필요한 모든 계산 완료
		pageUtil.setPageUtil(page, recordPerPage, totalRecord);
		
		// DB로 보낼 Map(begin + end)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		// DB에서 목록 가져오기
		List<NoticBoardDTO> noticBoardList = noticBoardMapper.selectNoticList(map);
		
		for(NoticBoardDTO notic : noticBoardList) {
			System.out.println(notic.toString());
		}
		
		// 뷰로 보낼 데이터
		model.addAttribute("noticBoardList", noticBoardList);
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "board/noticList?recordPerPage=" + recordPerPage));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		model.addAttribute("recordPerPage", recordPerPage);
		
	}
	
	@Override
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		
		// 파라미터 files
		MultipartFile multipartFile = multipartRequest.getFile("file");
		
		// 저장 경로
		String path = "C:" + File.separator + "summernoteImage";
				
		// 저장할 파일명
		String filesystem = myFileUtil.getFilename(multipartFile.getOriginalFilename());
		
		// 저장 경로가 없으면 만들기
		File dir = new File(path);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		// 저장할 File 객체
		File file = new File(path, filesystem);  
		
		// HDD에 File 객체 저장하기
		try {
			multipartFile.transferTo(file);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 저장된 파일을 확인할 수 있는 매핑을 반환
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("src", multipartRequest.getContextPath() + "/board/noticImage" + filesystem);  
		map.put("filesystem", filesystem);  
		return map;
	}
	
	@Override
	public void save(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		
//		int empNo = Integer.parseInt(multipartRequest.getParameter("empNo"));   // 우선 임의 empNo값 사용
		String title = securityUtil.preventXSS(multipartRequest.getParameter("boardTitle"));	// 코드 타입 chk(board내 통일 유무)
		String content = securityUtil.preventXSS(multipartRequest.getParameter("boardContent"));
		
		
		NoticBoardDTO notic = NoticBoardDTO.builder()
				.empNo(22120002)
				.boardTitle(title)
				.boardContent(content)
				.build();
				
		// DB에 noticBoard 저장
		int noticResult = noticBoardMapper.insertNotic(notic);
		
		// 응답
		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			 out.println("<script>");
			 if(noticResult > 0) {
				 
				 out.println("alert('게시글이 등록 되었습니다.');");
				 out.println("location.href='" + multipartRequest.getContextPath() + "/board/noticList';");
					
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
	public NoticBoardDTO getNoticByNo(int noticNo) {
		
		NoticBoardDTO noticBoard= noticBoardMapper.selectNoticByNo(noticNo);

		/* 자료실용
		 * List<SummernoteImageDTO> summernoteImageList
		 * =noticBoardMapper.selectSummernoteImageListInnoticBoard(noticNo);
		 * 
		 * if(summernoteImageList != null && summernoteImageList.isEmpty() == false) {
		 * for(SummernoteImageDTO summernoteImage : summernoteImageList) {
		 * if(noticBoard.getBoardContent().contains(summernoteImage.getFilesystem()) ==
		 * false) { File file = new File("C:" + File.separator + "summernoteImage",
		 * summernoteImage.getFilesystem()); if(file.exists()) { file.delete(); } } } }
		 */
		return noticBoard;
	}
	
	@Override
	public void modifyNotic(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		
		/*  수정 */
		// 파라미터
		int noticNo = Integer.parseInt(multipartRequest.getParameter("noticNo"));
		// int empNo = Integer.parseInt(multipartRequest.getParameter("empNo"));
		String title = multipartRequest.getParameter("boardTitle");
		String content = multipartRequest.getParameter("boardContent");
		
		// DB로 보낼 DTO
		NoticBoardDTO notic = NoticBoardDTO.builder()
				.noticNo(noticNo)
				// .empNo(empNo)
				.boardTitle(title)
				.boardContent(content)
				.build();
		
		// DB 수정
		int noticResult = noticBoardMapper.updateNotic(notic);
		
		System.out.println(" noticResult : " + noticResult) ;
		
		try {
			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			out.println("<script>");
			if(noticResult > 0) {
				/* 자료실용
				 * // 파라미터 summernoteImageNames String[] summernoteImageNames =
				 * multipartRequest.getParameterValues("summernoteImageNames");
				 * 
				 * // DB에 SummernoteImage 저장 if(summernoteImageNames != null) { for(String
				 * filesystem : summernoteImageNames) { SummernoteImageDTO summernoteImage =
				 * SummernoteImageDTO.builder() .imageNo(notic.getNoticNo())
				 * .filesystem(filesystem) .build();
				 * noticBoardMapper.insertSummernoteImage(summernoteImage); } }
				 */
				
				out.println("alert('게시글 수정이 완료 되었습니다.');");
				out.println("location.href='" + multipartRequest.getContextPath() + "/notic/detail?noticNo=" + noticNo + "'");
			} else {
				out.println("alert('게시글 수정에 실패했습니다.');");
				out.println("history.back();");
				}
			out.println("</script>");
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	@Override
	public void removeNotic(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("임플왔다");
		int noticNo = Integer.parseInt(request.getParameter("noticNo"));
		
		// List<SummernoteImageDTO> summernoteImageList = noticBoardMapper.selectSummernoteImageListInnoticBoard(noticNo);
			
		int result = noticBoardMapper.deleteNotic(noticNo);
		
	try {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		out.println("<script>");
		if(result > 0) {
			/* 자료실용
			 * // HDD 에서 SummernoteImage 리스트 삭제 if(summernoteImageList != null &&
			 * summernoteImageList.isEmpty()==false) { for(SummernoteImageDTO
			 * summernoteImage : summernoteImageList) { File file = new File("C:" +
			 * File.separator + "summernoteImage", summernoteImage.getFilesystem());
			 * if(file.exists()) { file.delete(); } } }
			 */

			out.println("alert('게시글이 삭제 되었습니다.');");
			out.println("location.href='" + request.getContextPath() + "board/noticList'");
		} else {
			out.println("alert('게시글 삭제에 실패했습니다.');");
			out.println("history.back();");
			}
		out.println("</script>");
		out.close();
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
}

/*
 * @Override public void findNoticList(HttpServletRequest request, Model model)
 * { Optional<String> opt =
 * Optional.ofNullable(request.getParameter("noticBoardNo")); int noticBoardNo =
 * Integer.parseInt(opt.orElse("0"));
 * 
 * NoticBoardDTO noticBoard = noticBoardMapper.selectBoardByNo(noticBoardNo);
 * model.addAttribute("NoticBoard", noticBoard); }
 */
	
	@Override
	public int increaseHit(int noticNo) {
		return noticBoardMapper.updateHit(noticNo);
	}
	
	
}