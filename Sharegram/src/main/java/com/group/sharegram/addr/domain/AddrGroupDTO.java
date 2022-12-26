package com.group.sharegram.addr.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddrGroupDTO {
	public int addrGroupNo;
	public int empNo;
	public String addrGroupName;
}
