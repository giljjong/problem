package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.DeptHrCommentDTO;

@Mapper
public interface DeptHrCommentMapper {
	
	public int selectCommentCount (int boardNo);
	public int insertComment(DeptHrCommentDTO cmt);
	public List<DeptHrCommentDTO>selectCommentList(Map<String, Object>map);
	public int deleteComment(int cmtNo);
	public int insertReply(DeptHrCommentDTO cmt);
	public int updateGroupNo(DeptHrCommentDTO cmt);
}
