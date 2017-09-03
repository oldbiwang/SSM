package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;


/**
 * @author cjc
 *
 */
@Service
public class EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	/**
	 * 查询所有员工
	 * @return
	 */
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleDept(null);
	}

	public void saveEmp(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insert(employee);
	}

	
	/**
	 * 检验用户名是否可用
	 * @param empName
	 * @return true 代表当前姓名可用
	 */
	public boolean checkUser(String empName) {
		// TODO Auto-generated method stub
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		employeeMapper.countByExample(example);
		return count == 0;
	}

	/**
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		// TODO Auto-generated method stub
		Employee employee =  employeeMapper.selectByPrimaryKey(id);
		return employee;
	}

	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
		
	}

	public void deleteEmp(Integer id) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(id);
	}

	public void deleteBatch(List<Integer> ids) {
		// TODO Auto-generated method stub
		EmployeeExample employeeExample = new EmployeeExample();
		Criteria criteria = employeeExample.createCriteria();
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(employeeExample);
	}
}
