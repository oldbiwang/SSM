package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.dao.DepartmentMapper;

/**
 * DepartmentService
 * @author cjc
 *
 */
@Service
public class DepartmentService {
	
	@Autowired
	private DepartmentMapper departmentMapper;
	public List<Department> getDepts() {
		//查出的所有部门信息
		List<Department> list = departmentMapper.selectByExample(null);
		return list;
	}
}
