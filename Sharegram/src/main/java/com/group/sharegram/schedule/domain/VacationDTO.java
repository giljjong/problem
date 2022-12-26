package com.group.sharegram.schedule.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VacationDTO {
	private int empNo;
	private String vacationCategory;  //휴가종류
	private String vacationStart;    //휴가 시작일
	private String vacationEnd;     //휴가 종료일
	private int vacation_count;    // 휴가 일수
}
