package com.gdu.mail.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.mail.domain.AddrGroupDTO;
import com.gdu.mail.domain.DepartmentsDTO;
import com.gdu.mail.domain.EmpAddrDTO;
import com.gdu.mail.domain.PersonalAddrDTO;

@Mapper
public interface AddressMapper {
	public EmpAddrDTO selectEmpAddrByNo(int empNo);
	public int insertEmpAddr(EmpAddrDTO empInfo);
	public int insertUnspecifiedGroup(int empNo);
	public List<DepartmentsDTO> selectDeptList();
	public List<AddrGroupDTO> selectMyAddrGroupList(int empNo);
	public List<PersonalAddrDTO> selectImportantPersonalAddr(Map<String, Object> map);
}
