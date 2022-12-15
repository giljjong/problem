package com.gdu.mail.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JamesUserDTO {
	private String userName;
	private String passwordHashAlgorithm;
	private String password;
	private int version;
}
