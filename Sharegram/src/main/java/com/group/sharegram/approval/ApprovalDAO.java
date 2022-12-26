package com.group.sharegram.approval;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("apDao")
public class ApprovalDAO {
	@Autowired
	private SqlSession sqlSession;
	
	
	public int listCount() {
		return sqlSession.selectOne("Approval.listCount");
	}
	
	public int insertApproval(ApprovalDTO dto) { // 기안작성
		return sqlSession.insert("Approval.insertApproval", dto);
	}
	
	public List<ApprovalDTO> selectList(int startPage, int limit, String empNo){
		int startRow = (startPage - 1) * limit; // 시작 페이지를 가져옴, 0~9, 10~19
		RowBounds row = new RowBounds(startRow, limit); //ibatis 세션의 rowboun
		return sqlSession.selectList("Approval.selectList", empNo, row);
	}
	
	public ApprovalDTO selectOne(String apNo) { //글 가져오기
		return sqlSession.selectOne("Approval.selectOne", apNo);
		
	}
	
	public int stateupdate(ApprovalDTO dto) { //결재완료
		return sqlSession.update("Approval.updatestate",dto);
	}
	
	public int updateaprejection(ApprovalDTO dto)  { //반려사유
		return sqlSession.update("Approval.updateaprejection",dto);
	}
	

}