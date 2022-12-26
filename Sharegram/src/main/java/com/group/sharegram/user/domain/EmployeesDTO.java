package com.group.sharegram.user.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmployeesDTO {
	
		private int empNo; // 사원 번호(id)
		private String empPw; // 비밀번호
		private String name; // 이름
		private String birthyear; // 생년
		private String birthday; // 월일
		private String phone; // 핸드폰 번호
		private int salary; // 월급
		private int jobNo; // 직급 번호
		private int deptNo; // 부서 번호
		private String profImg; // 프로필 사진
		private String status; // 근무상태
		
		
		private Date joinDate; // 입사일자
		private Date infoModifyDate; // 정보 변경일
		
		
		
		private DepartmentsDTO departmentsDTO;
		private PositionDTO positionDTO;
		
	

}
