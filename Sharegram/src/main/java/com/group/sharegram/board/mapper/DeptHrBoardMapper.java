package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.DeptHrBoardDTO;

@Mapper
public interface DeptHrBoardMapper {
	public int selectAllDeptHrListCount();
	public List<DeptHrBoardDTO> selectDeptHrList(Map<String, Object> map);
	public int insertDeptHr(DeptHrBoardDTO deptHr);
	
	public DeptHrBoardDTO selectBoardByNo(int boardNo);

	public int updateDeptHr(DeptHrBoardDTO deptHr);
	public int deleteDeptHr(int boardNo);
	
	public int updateHit(int boardNo);

}
