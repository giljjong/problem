package com.group.sharegram.company;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group.sharegram.company.CompanyDAO;

@Service("companyService")
public class CompanyServiceImpl implements CompanyService{
	@Autowired
	CompanyDAO companydao;

	@Override
	public String SelectCEO(String cno) throws Exception {
		return companydao.SelectCEO(cno);
	}
	
	
	//@Override
//	public String findCno(String curl) throws Exception {
//		return companydao.findCno(curl);
//	}

}