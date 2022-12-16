package com.gdu.mail.domain;

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
	private String name;
	private String password;
	private String phone;
	private String email;
	private String fax;
	private String memo;
	
}
