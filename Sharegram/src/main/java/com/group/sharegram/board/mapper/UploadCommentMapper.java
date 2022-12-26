package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.UploadCommentDTO;

@Mapper
public interface UploadCommentMapper {
	
	public int selectCommentCount (int boardNo);
	public int insertComment(UploadCommentDTO cmt);
	public List<UploadCommentDTO>selectCommentList(Map<String, Object>map);
	public int deleteComment(int cmtNo);
	public int insertReply(UploadCommentDTO cmt);
}
