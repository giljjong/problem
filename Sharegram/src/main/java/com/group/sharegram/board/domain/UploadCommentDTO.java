package com.group.sharegram.board.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder

public class UploadCommentDTO {
	private int cmtNo;
	private int boardNo;
	private int empNo;

	private Date createDate;
	private String cmtContent;

	private int state;
	private int depth;
	private int groupNo;


}
