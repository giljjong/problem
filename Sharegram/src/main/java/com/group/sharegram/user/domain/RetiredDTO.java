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
public class RetiredDTO {
	
		private int empNo;
		private String name;
		private String phone;
		private Date joinDate;
		private Date retiredDate;
		private int jobNo;
		private int deptNo;
	
		
		
	

}
