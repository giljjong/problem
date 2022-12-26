package com.group.sharegram.approval;

import java.util.List;

public interface ApprovalService {
	public int totalCount();
	public void insertApproval(ApprovalDTO dto) throws Exception;
	public List<ApprovalDTO> selectList(int startPage, int limit, String uno);
	public int listCount();
	public ApprovalDTO selectOne(int chk, String apno);
	
	public ApprovalDTO stateupdate(ApprovalDTO dto);
	public ApprovalDTO updateaprejection(ApprovalDTO dto);

}