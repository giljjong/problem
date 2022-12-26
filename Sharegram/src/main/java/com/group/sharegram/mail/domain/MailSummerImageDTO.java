package com.group.sharegram.mail.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class MailSummerImageDTO {
	private int mailNo;
	private String path;
	private String filesystem;
}