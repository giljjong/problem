package com.group.sharegram.schedule.controller;

import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.group.sharegram.schedule.service.AttendanceService;

@RestController
public class AttendanceController {
	
	@Autowired
	private AttendanceService attendanceService;
	
	@PostMapping(value="/attendance", produces = "application/json")
	public ResponseEntity<Object> addAttendance(@RequestParam(value="attendance", required=false) Optional<String> opt , @RequestParam(value="empNo", required=false) Optional<String> opt2 ) {
		int attendance = Integer.parseInt(opt.orElse("0"));
		int empNo = Integer.parseInt(opt2.orElse("0"));
		return attendanceService.addAttendance(attendance , empNo);
	}
	
	@PutMapping(value="/members", produces="application/json")
	public ResponseEntity<Object> modifyMember(@RequestBody Map<String, Object> map) {
		return attendanceService.modifyAttendance(map);
	}
	
	@GetMapping(value="/attendance", produces="application/json")
	public ResponseEntity<Object> getAttendanceList(@PathVariable(value="page", required=false) Optional<String> opt) {
		int page = Integer.parseInt(opt.orElse("1")); 
		
		return attendanceService.getAttendanceList(page);
	}
	
	@GetMapping(value="/attendance/{attNo}", produces="application/json")
	public ResponseEntity<Object> getMember(@PathVariable(value="attNo", required=false) Optional<String> opt) {
		int attNo = Integer.parseInt(opt.orElse("0"));
		return attendanceService.getAttendacneByNo(attNo);
	}
	
	@DeleteMapping(value="/attendance/{attendanceNoList}", produces="application/json")
	public ResponseEntity<Object> removeMemberList(@PathVariable String attendanceNoList) {
		return attendanceService.removeAttendanceList(attendanceNoList);
	}
	
	
}
