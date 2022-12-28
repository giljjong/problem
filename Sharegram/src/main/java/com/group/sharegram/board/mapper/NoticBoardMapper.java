package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.NoticBoardDTO;
import com.group.sharegram.board.domain.SummernoteImageDTO;

@Mapper
public interface NoticBoardMapper {
	public int selectAllNoticListCount();
	public List<NoticBoardDTO> selectNoticList(Map<String, Object> map);
	public int insertSummernoteImage(SummernoteImageDTO summernote);
	public int insertNotic(NoticBoardDTO notic);

	public NoticBoardDTO selectNoticByNo(int noticNo);
	
	public int updateNotic(NoticBoardDTO notic);
	public int deleteNotic(int noticNo);
//	public int insertContent(NoticBoardDTO uploadBoard);
	
	 
	public int updateHit(int noticNo);
	public int updateNoticTop(Map<String, Object> map);
	
	
	/* 자료실용
	 * public List<SummernoteImageDTO> selectSummernoteImageListInnoticBoard(int
	 * noticNo); public List<SummernoteImageDTO> selectAllSummernoteImageList();
	 */
	
}
