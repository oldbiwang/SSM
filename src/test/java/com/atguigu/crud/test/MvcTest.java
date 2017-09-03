package com.atguigu.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.atguigu.crud.bean.Employee;
import com.github.pagehelper.PageInfo;

/**
 * 使用 Spring 测试模块提供
 * @author cjc
 *
 */

@RunWith(SpringJUnit4ClassRunner.class)
/*这个注解没有写的话，没办法自动装配 mvc 的 WebApplicationContext，会报 
 *  org.springframework.beans.factory.NoSuchBeanDefinitionException:
 *  No qualifying bean of type 'org.springframework.web.context.WebApplicationContext'
 * */

/*
 * spring 4 测试的时候
 * servlet 需要 3.0 或以上版本，否则会报错 
 * java.lang.NoClassDefFoundError: javax/servlet/SessionCookieConfig
 * 
 * */
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
public class MvcTest {
	@Autowired
	WebApplicationContext context;
	
	//虚拟 mvc
	MockMvc mockMvc;
	
	@Before
	public void initMockMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
	
	@Test
	public void testPage() throws Exception {
		System.out.println("mockMvc = " + mockMvc);
		//模拟请求，拿到返回值
		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5"))
				.andReturn();
		
		//取出 pageInfo 进行验证
		MockHttpServletRequest request = result.getRequest();
		PageInfo pi = (PageInfo)request.getAttribute("pageInfo");
		System.out.println("当前页码：" + pi.getPageNum());
		System.out.println("总页码：" + pi.getPages());
		System.out.println("总记录数：" + pi.getTotal());
		System.out.println("在页面需要连续显示的页码");
		int[] nums = pi.getNavigatepageNums();
		for(int i : nums) {
			System.out.println("  " + i);
		}
		//获取员工数据
		List<Employee> list = pi.getList();
		for(Employee employee : list) {
			System.out.println("ID " + employee.getEmpId() + "==>name" + employee.getEmpName());
		}
	}
}
