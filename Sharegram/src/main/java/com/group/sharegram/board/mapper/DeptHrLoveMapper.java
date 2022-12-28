package com.group.sharegram.board.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DeptHrLoveMapper {
	
	public int selectUserLoveCount(Map<String, Object> map);
	public int selectBoardLoveCount(int boardNo);
	public int insertLove(Map<String, Object> map);
	public int deleteLove(Map<String, Object> map);
	
}
