package com.group.sharegram2.addr.domain;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpAddrDTO {
	
	private int empAddrNo;
	private int empNo;
	private int deptNo;
	private int jobNo;
	private String name;
	private String password;
	private String phone;
	private String email;
	private String fax;
	private String memo;
	
	// 추가 항목
	private String receiveType;
	private String deptName;
	private String jobName;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date joinDate;
	
}
