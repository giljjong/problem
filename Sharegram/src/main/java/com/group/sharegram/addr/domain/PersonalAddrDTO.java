package com.group.sharegram.addr.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PersonalAddrDTO {
	private int personalNo;
	private int addrGroupNo;	// 수정
	private String addrName;
	private String addrPhone;
	private String company;
	private String email;
	private String fax;
	private String memo;
	private String importantCheck;
	
	// 추가
	private String addrGroupName;
}
