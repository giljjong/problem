package com.group.sharegram.schedule.service;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.group.sharegram.schedule.domain.AttendanceDTO;

public interface AttendanceService {
	public Map<String , String > attendanceCheck(int empNo);
	public ResponseEntity<Object> addAttendance(int attendance , int empNo);
	
	
	public ResponseEntity<Object> getAttendanceList(int page);
	public void attendanceListCheck();
	public ResponseEntity<Object> getAttendacneByNo(int attNo);
	public ResponseEntity<Object> modifyAttendance (Map<String, Object> map);
	public ResponseEntity<Object> removeAttendanceList (String attendacneNoList);
}
