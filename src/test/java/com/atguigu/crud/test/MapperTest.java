package com.atguigu.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.ApplicationContext;
//import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

//import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

/**
 * 测试 dao 层的工作
 * @author cjc
 *
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {

	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	
	/*
	 * 测试 department 
	 * */
	@Test
	public void testCrud() {
		/*//1.创建 SpringIOC 容器
		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
		//2. 从容器中获取Mapper
		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);*/
		System.out.println(departmentMapper);
		
		//1. 插入几个部门
		//	departmentMapper.insertSelective(new Department(null, "开发部"));
		//	departmentMapper.insertSelective(new Department(null, "测试部"));
		
		//2.生成员工数据
		//employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@atguigu.com",1));
		
		//3.使用 sqlSession 批量插入多个员工
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i = 0;i < 1000; i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5) + i;
			mapper.insertSelective(new Employee(null, uid, "M", "@atguigu.com", 1));
		}
		System.out.println("批量执行完！");
	}
		
}
