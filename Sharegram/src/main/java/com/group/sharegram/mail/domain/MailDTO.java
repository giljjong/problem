package com.group.sharegram.mail.domain;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MailDTO {
	private int mailNo;
	private int empNo;
	private String sender;
	private String subject;
	private String mailContent;
	private Date sendDate;
	private String sendStatus;
	private int tagNo;
	
	// 추가 정보
	private String empName;
	private String from;
	private String receiveDate;
	
	// 읽음 및 삭제 정보
	private String readCheck;
	private String deleteCheck;
	private String receiveType;
	
	// 받는 사람
	private String strTo;
	private String strCc;
	private String[] toAddr;
	private String[] ccAddr;
}
