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
	public int selectReceiveMailCount(Map<String, Object> map);
	public List<MailDTO> selectReceiveMailList(Map<String, Object> map);
	public int selectSendMailCount(Map<String, Object> map);
	public List<MailDTO> selectSendMailList(Map<String, Object> map);
	public int selectReadNotReceiveCount(Map<String, Object> map);
	public List<ReceiversDTO> selectReceiverList(int mailNo);
	public ReceiversDTO selectReceiverByMap(Map<String, Object> map);
	public ReceiversDTO selectSendReceiverByMap(Map<String, Object> map);
	public int updateCheckByMap(Map<String, Object> map);
	public int selectReadNotSendCount(int empNo);
}
