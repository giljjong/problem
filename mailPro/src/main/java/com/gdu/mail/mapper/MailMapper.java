package com.gdu.mail.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;

@Mapper
public interface MailMapper {
	public int insertJamesUser(EmpAddrDTO empInfo);
	public MailDTO selectMailByEmail(String email);
	public int insertMail(MailDTO mail);
	public int insertReceivers(int empNo);
}
