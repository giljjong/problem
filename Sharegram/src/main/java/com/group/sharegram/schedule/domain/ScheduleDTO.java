package com.group.sharegram.schedule.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Data
public class ScheduleDTO {
	private int scheduleNo;
	private int empNo;
	private String scheduleTitle;
	private String scheduleStart;
	private String scheduleEnd;
	private String scheduleAllday;
}
