package com.group.sharegram.schedule.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.group.sharegram.schedule.domain.ScheduleDTO;
import com.group.sharegram.schedule.service.ScheduleService;

@RestController
public class ScheduleController {

	@Autowired
	private ScheduleService scheduleService;


	@GetMapping(value= "/schedule", produces = "application/json")
	public ResponseEntity<Object> getScheduleList() {
		return scheduleService.getScheduleList();
	}
	
	@PostMapping(value="/schedule", produces = "application/json")
	public ResponseEntity<Object> addSchedule(@RequestBody ScheduleDTO schedule) {
		return scheduleService.addSchedule(schedule);
	}
	
	@PutMapping(value="/schedule", produces = "application/json")
	public ResponseEntity<Object> modifySchedule(@RequestBody ScheduleDTO schedule) {
		return scheduleService.modifySchedule(schedule);
	}
	
	@DeleteMapping(value="/schedule", produces="application/json")
	public ResponseEntity<Object> removeMemberList(@RequestBody ScheduleDTO schedule) {
		return scheduleService.removeSchedule(schedule);
	}
}
