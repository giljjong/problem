package com.group.sharegram.schedule.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.schedule.domain.ScheduleDTO;

@Mapper
public interface ScheduleMapper {
	
	public List<ScheduleDTO> selectScheduleList();
	public int insertSchedule(ScheduleDTO schedule);
	public int updateSchedule(ScheduleDTO schedule);
	public int deleteSchedule(ScheduleDTO schedule);
}
