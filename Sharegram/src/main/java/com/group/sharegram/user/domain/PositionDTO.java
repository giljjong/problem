package com.group.sharegram.user.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PositionDTO {
	
		private int jobNo; // 직급 번호
		private String jobName; // 직급
	
}
