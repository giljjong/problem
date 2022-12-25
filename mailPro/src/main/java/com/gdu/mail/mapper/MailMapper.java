package com.gdu.mail.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.MailAtchDTO;
import com.gdu.mail.domain.MailDTO;
import com.gdu.mail.domain.ReceiversDTO;
import com.gdu.mail.domain.SummernoteImageDTO;

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
	public int[] selectReceiveEmp(int mailNo);
	public int insertSummernoteImage(SummernoteImageDTO summernote);
	public SummernoteImageDTO selectSummernoteImageListInMail(int mailNo);
	public SummernoteImageDTO selectAllSummernoteImageList();
	public int deleteSummernoteImage(String filesystem);
	public int insertMailAttach(MailAtchDTO attach);
	public List<MailAtchDTO> selectMailAttachList(int mailNo);
	public MailAtchDTO selectMailAttachByNo(int fileNo);
	public int insertMailAttachByFileNo(int fileNo);
	public int deleteReceiver(Map<String, Object> map);
}
