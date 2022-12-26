package com.group.sharegram2.mail.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReceiversDTO {
	private int empNo;
	private int mailNo;
	private String readCheck;
	private String deleteCheck;
	private String receiveType;
}
