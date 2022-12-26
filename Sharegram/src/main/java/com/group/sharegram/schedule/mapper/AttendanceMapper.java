package com.group.sharegram.schedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.schedule.domain.AttendanceDTO;


@Mapper
public interface AttendanceMapper {
	public int insertAttendacne(AttendanceDTO attendacne);
	public int updateLeaveWork(AttendanceDTO attendacne);
	public AttendanceDTO selectAttendanceCheck(AttendanceDTO attendacne);
	public AttendanceDTO selectAttendacneByNo(int memberNo);
	public int updateAttendacne(Map<String, Object> map);
	
	public List<AttendanceDTO> selectAttendanceListByMap(Map<String, Object> map);
	public List<AttendanceDTO> selectAttendanceListCheck();
	public int selectAttendaceCount();
	
	public int deleteAttendacneList(List<String> attendanceNoList);
}
