package com.group.sharegram.schedule.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AnnualDTO {
	private int annualNo;
	private int empNo;
	private int annualLeave; //남은연차
}
