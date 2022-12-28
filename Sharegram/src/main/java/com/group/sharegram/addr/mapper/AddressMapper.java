package com.group.sharegram.addr.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.addr.domain.AddrGroupDTO;
import com.group.sharegram.addr.domain.EmpAddrDTO;
import com.group.sharegram.addr.domain.PersonalAddrDTO;
import com.group.sharegram.user.domain.DepartmentsDTO;

@Mapper
public interface AddressMapper {
	public EmpAddrDTO selectEmpAddrByNo(int empNo);
	public int insertEmpAddr(EmpAddrDTO empInfo);
	public int insertUnspecifiedGroup(int empNo);
	public List<DepartmentsDTO> selectDeptList();
	public List<AddrGroupDTO> selectMyAddrGroupList(int empNo);
	public int selectImportantPersonalAddrCnt(int empNo);
	public List<PersonalAddrDTO> selectImportantPersonalAddr(Map<String, Object> map);
	public int selectEmpAddrByDeptNoCnt(int deptNo);
	public List<EmpAddrDTO> selectEmpAddrListByDeptNo(Map<String, Object> map);
	public EmpAddrDTO selectEmpAddrByEmpNo(int empNo);
	public int insertAddrGroup(AddrGroupDTO group);
	public int insertPersonalAddr(PersonalAddrDTO pAddr);
	public List<PersonalAddrDTO> selectPersonalAddrListInGroup(Map<String, Object> map);
	public int selectPersonalAddrListInGroupCnt(int groupNo);
	public int deletePersonalAddr(int personalNo);
	public PersonalAddrDTO selectPersonalAddr(int personalNo);
	public int updateImportantFromPersonalAddr(PersonalAddrDTO person);
	public int updateAddrGroupName(AddrGroupDTO group);
	public int deleteAddrGroup(int addrGroupNo);
}
