package com.gdu.mail.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.EmpAddrDTO;

@Mapper
public interface AddrMapper {
	public EmpAddrDTO selectEmpAddrByNo(int empNo);
	public int insertEmpAddr(EmpAddrDTO empInfo);
}
