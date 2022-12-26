package com.group.sharegram2.mail.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MailAtchDTO {
	private int fileNo;
	private int mailNo;
	private String originName;
	private String changeName;
	private String mailPath;
	private Date uploadDate;
	private int hasThumbnail;
	
	// 추가
	private String name;
}
