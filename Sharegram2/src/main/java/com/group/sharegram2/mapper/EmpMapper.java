package com.group.sharegram2.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram2.addr.domain.EmployeesDTO;

@Mapper
public interface EmpMapper {
	public int insertDept(String deptName);
	public int insertPosition(String jobName);
	public int insertEmp(EmployeesDTO emp);
	public EmployeesDTO selectEmpByMap(Map<String, Object> map);
}
