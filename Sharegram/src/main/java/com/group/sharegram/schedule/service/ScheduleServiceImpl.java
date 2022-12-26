package com.group.sharegram.schedule.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.group.sharegram.schedule.domain.ScheduleDTO;
import com.group.sharegram.schedule.mapper.ScheduleMapper;

@Service
public class ScheduleServiceImpl implements ScheduleService {

	@Autowired
	ScheduleMapper scheduleMapper;

	@Override
	public ResponseEntity<Object> getScheduleList() {
		
		System.out.println("리스트반환");
		System.err.println(scheduleMapper.selectScheduleList());
		List<ScheduleDTO> list = scheduleMapper.selectScheduleList();
		return new ResponseEntity<Object>(list, HttpStatus.OK);
	}

	@Override
	public ResponseEntity<Object> addSchedule(ScheduleDTO schedule) {
		
		if(schedule.getScheduleTitle().isEmpty() ) {
			schedule.setScheduleTitle("제목없음");
		} 
		schedule.setEmpNo(1);
		System.out.println("추가 : " + schedule);
		Map<String, Object> result = new HashMap<String, Object>();
		int insertResult = scheduleMapper.insertSchedule(schedule);
		result.put("insertResult", insertResult);

		if (insertResult > 0) {
			System.out.println("추가성공");
			HttpHeaders headers = new HttpHeaders();
			return new ResponseEntity<Object>(result, HttpStatus.OK);
		} else {
			return new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@Override
	public ResponseEntity<Object> modifySchedule(ScheduleDTO schedule) {
		
		schedule.setEmpNo(1);
		Map<String, Object> result = new HashMap<String, Object>();
		int updateResult = scheduleMapper.updateSchedule(schedule);
		result.put("updateResult", updateResult );
		
		if(updateResult > 0) {
			System.out.println("수정성공");
			return new ResponseEntity<Object>(result, HttpStatus.OK);
		} else {
			return new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
	}
	
	@Override
	public ResponseEntity<Object> removeSchedule(ScheduleDTO schedule) {
		schedule.setEmpNo(1);
		Map<String, Object> result = new HashMap<String, Object>();
		int deleteResult = scheduleMapper.deleteSchedule(schedule);
		result.put("deleteResult", deleteResult );
		
		if(deleteResult > 0) {
			System.out.println("삭제성공");
			return new ResponseEntity<Object>(result, HttpStatus.OK);
		} else {
			return new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
}
