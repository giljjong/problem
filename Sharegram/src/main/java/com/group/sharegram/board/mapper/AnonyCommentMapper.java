package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.AnonyCommentDTO;

@Mapper
public interface AnonyCommentMapper {
	public int selectCommentCount(int anonyNo);
	public int insertComment(AnonyCommentDTO comment);
	public List<AnonyCommentDTO> selectCommentList(Map<String, Object> map);
	public int deleteComment(int commentNo);
	public int insertReply(AnonyCommentDTO reply);
}
