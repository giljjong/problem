package com.group.sharegram.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.approval.ApprovalDTO;

@Mapper
public interface ApprovalMapper {
	public List<ApprovalDTO> listCount();
	public void selectList();
	public void insertApproval();
	public void updatestate();
	public void updateaprejection();
	public void selectOne();
}
