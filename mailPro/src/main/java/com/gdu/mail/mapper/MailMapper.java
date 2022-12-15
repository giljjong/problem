package com.gdu.mail.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.JamesUserDTO;

@Mapper
public interface MailMapper {
	public int insertJamesUser(JamesUserDTO jamesUser);
	public JamesUserDTO selectJamesUserByEmpNo(String userName);
}
