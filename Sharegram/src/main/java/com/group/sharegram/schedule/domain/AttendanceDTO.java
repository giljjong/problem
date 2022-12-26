package com.group.sharegram.schedule.domain;

import com.group.sharegram.user.domain.EmployeesDTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceDTO {
	private int attNo;
	private int empNo;
	private String attStart;   //출근시간
	private String attEnd;     //퇴근시간
	private String attDate;    //근무일자
	private String attDay;     //근무요일
	private String attStatus;  //근무상태
	private String earlyContent;  
	private String earlyStatus;  
	
	private String working;
	private String overWorking;
	private EmployeesDTO empDTO;
}
