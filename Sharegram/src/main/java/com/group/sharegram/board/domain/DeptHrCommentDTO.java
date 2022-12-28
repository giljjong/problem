package com.group.sharegram.board.domain;

import java.sql.Date;

import com.group.sharegram.user.domain.EmployeesDTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class DeptHrCommentDTO {
	
	private int commentNo;
	private int anonyNo;
	private String content;
	private int state;
	private int depth;
	private int groupNo;
	private Date createDate;
	private EmployeesDTO user;
	
}
