package com.group.sharegram.user.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.user.domain.EmployeesDTO;
import com.group.sharegram.user.domain.RetiredDTO;



@Mapper
public interface EmpMapper {
	
	
	
	
	
	public EmployeesDTO selectEmpByMap(Map<String, Object>map); 
	public RetiredDTO selectRetireEmpByNo(int empNo);
	
	public int insertEmp(EmployeesDTO emp); // 직원 등록(인사부 부장 권한)
	public int insertRetireEmp (RetiredDTO retireEmp); // 퇴사자 등록(인사부 부장 권한)

	public int updateEmp(EmployeesDTO emp); // 직원 수정(인사 부 부장 권한)
	
	public int updateMyPassword(EmployeesDTO emp); // 마이페이지:비밀번호 ** 비번변경 해야됨 **
	public int updateMyinfo(EmployeesDTO emp); // 마이페이지:내 정보 수정 ** 해야됨 **
	
	
	
	
	public int selectAllEmpListCnt(); // 직원 리스트 카운트용
	/* public List<EmployeesDTO> selectEmpPage (Map<String, Object>map); */
	
	public List<EmployeesDTO> selectEmpByPage(Map<String, Object>map);
	
	
	
	
	
	
	
}
