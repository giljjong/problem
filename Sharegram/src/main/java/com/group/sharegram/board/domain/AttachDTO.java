package com.group.sharegram.board.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class AttachDTO {
	
	private int attachNo;
	private int uploadNo;
	private int empNo;
	private String path;
	private String origin;
	private String filesystem;

	// 썸네일 구성 생각중
	private int hasThumbnail;
	
}
