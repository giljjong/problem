package com.group.sharegram.approval;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;


@Service("ApproService")
@Repository
public class ApprovalServiceImpl implements ApprovalService {
	
	@Autowired
	private ApprovalDAO apDao;
	
	@Override
	public int totalCount() {
		return apDao.listCount();
	}
	
	@Override
	public void insertApproval(ApprovalDTO dto) throws Exception{
		apDao.insertApproval(dto);
	}
	
	@Override
	public List<ApprovalDTO> selectList(int startPage, int limit, String uno) {
		return apDao.selectList(startPage,limit,uno);
	}

	@Override
	public int listCount() {
		return apDao.listCount();
	}

	@Override
	public ApprovalDTO selectOne(int chk,String apno) {
		return apDao.selectOne(apno);
	}

	@Override
	public ApprovalDTO stateupdate(ApprovalDTO dto) {
		int result = apDao.stateupdate(dto);
		if (result > 0) {
			dto = apDao.selectOne(dto.getApNo());
		} else {
			dto = null;
		}
			
		return dto;
	}

	@Override
	public ApprovalDTO updateaprejection(ApprovalDTO dto) {
		int result = apDao.updateaprejection(dto);
		if(result > 0 ) {
			dto = apDao.selectOne(dto.getApNo());
		} else {
			dto = null;
		}
		
		return dto;
		
	}
		

}
