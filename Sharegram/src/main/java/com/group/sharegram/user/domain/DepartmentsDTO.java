package com.group.sharegram.user.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DepartmentsDTO {
	
	private int deptNo; // 부서 번호
	private String deptName; // 부서
	
	

}
