package com.gdu.mail.domain;

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
	private int empNo;
	private String empPw;
	private String name;
	private String birthday;
	private Date joinDate;
	private String profImg;
	private Date infoModifyDate;
	private String status;
	private int salary;
	private int jobNo;
	private int deptNo;
	
}
