package com.gdu.mail.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;

@Mapper
public interface MailMapper {
	public int insertJamesUser(EmpAddrDTO empInfo);
	public MailDTO selectMailByMap(Map<String, Object> map);
	public int insertMail(MailDTO mail);
	public int insertReceivers(Map<String, Object> map);
	public int selectReceiveMailCount(int empNo);
	public List<MailDTO> selectReceiveMailList(Map<String, Object> map);
	public int selectReadNotCount(int empNo);
	public List<ReceiversDTO> selectReceiverList(int mailNo);
}
