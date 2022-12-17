package com.gdu.mail.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;

@Mapper
public interface MailMapper {
	public int insertJamesUser(EmpAddrDTO empInfo);
	public MailDTO selectMailByEmail(String email);
	public int insertMail(MailDTO mail);
	public int insertReceivers(int empNo);
	public int selectReceiveCount(int empNo);
	public List<MailDTO> selectReceiveList(Map<String, Object> map);
	public int selectReadNotCount(int empNo);
}
