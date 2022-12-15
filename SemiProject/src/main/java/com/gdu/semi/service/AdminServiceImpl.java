package com.gdu.semi.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.gdu.semi.mapper.AdminMapper;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	@Override
	public void findAllUsers(Model model) {
		model.addAttribute("userList", adminMapper.selectUserList());
		model.addAttribute("sleepUserList", adminMapper.selectSleepUserList());
	}
}
