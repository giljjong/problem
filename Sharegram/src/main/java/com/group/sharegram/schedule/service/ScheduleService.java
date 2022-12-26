package com.group.sharegram.schedule.service;

import org.springframework.http.ResponseEntity;

import com.group.sharegram.schedule.domain.ScheduleDTO;

public interface ScheduleService {
	
	public ResponseEntity<Object> getScheduleList();
	public ResponseEntity<Object> addSchedule(ScheduleDTO  schedule);
	public ResponseEntity<Object> modifySchedule(ScheduleDTO  schedule);
	public ResponseEntity<Object> removeSchedule(ScheduleDTO  schedule);
	
	
}
