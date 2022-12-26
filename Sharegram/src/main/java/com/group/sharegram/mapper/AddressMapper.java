package com.group.sharegram.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.domain.DepartmentsDTO;
import com.group.sharegram.addr.domain.EmpAddrDTO;
import com.group.sharegram.addr.domain.PersonalAddrDTO;

@Mapper
public interface AddressMapper {
	public EmpAddrDTO selectEmpAddrByNo(int empNo);
	public int insertEmpAddr(EmpAddrDTO empInfo);
	public int insertUnspecifiedGroup(int empNo);
	public List<DepartmentsDTO> selectDeptList();
	public List<AddrGroupDTO> selectMyAddrGroupList(int empNo);
	public int selectImportantPersonalAddrCnt(int empNo);
	public List<PersonalAddrDTO> selectImportantPersonalAddr(Map<String, Object> map);
	public int insertPersonalAddr(PersonalAddrDTO addr);
	public int selectEmpAddrByDeptNoCnt(int deptNo);
	public List<EmpAddrDTO> selectEmpAddrListByDeptNo(Map<String, Object> map);
	public EmpAddrDTO selectEmpAddrByEmpNo(int empNo);
	public int insertAddrGroup(AddrGroupDTO group);
}
