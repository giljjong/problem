package com.group.sharegram.schedule.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ScheduleMoveController {

	@GetMapping(value = "/schedule/list" , produces = "application/json")
	public String Calander() {
		return "schedule/calander";
	}
	
	@GetMapping(value = "/schedule/write" , produces = "application/json")
	public String writeCalendar(HttpServletRequest request, Model model) {
		String start =  request.getParameter("start");
		String end = request.getParameter("end");
		String allday = request.getParameter("allday");
		model.addAttribute("start" , start);
		model.addAttribute("end" , end);
		model.addAttribute("allday" , allday);
	return "schedule/calendarWrite";
	}
	
	@GetMapping(value = "/attendance/list" , produces = "application/json")
	public String getAttendaceList() {
		return "schedule/attendance";
	}
}
