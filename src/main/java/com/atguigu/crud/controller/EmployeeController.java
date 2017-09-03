package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import net.sf.jsqlparser.statement.create.table.Index;


/**
 * 处理员工请求
 * @author cjc
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService  employeeService;
	
	@ResponseBody
	@RequestMapping(value="/emp/{ids}", method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("ids")String ids) {
		if(ids.contains("-")) {
			List<Integer> del_ids = new ArrayList<>();
			String[] str_ids = ids.split("-");
			for(String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		} else {
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		
		return Msg.success();
	}
	
	@ResponseBody
	@RequestMapping(value="/emp/{empId}", method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee) {	
		System.out.println(employee);
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	@RequestMapping(value="/emp/{id}", method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id) {
		System.out.println(id);
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	/*检查用户名是否可用*/
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName")String empName) {
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "用户名必须是 6-16 位数字和字母的组合或者2-5位中文");
		}
		
		boolean b = employeeService.checkUser(empName);
		if(b) {
			return Msg.success();
		} else {
			return Msg.fail().add("va_msg", "用户名不可用");
		}
	}
	
	@RequestMapping(value="/emp", method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		if(result.hasErrors()) {
			//校验失败，返回失败
			Map<String, Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors) {
				System.out.println(" 错误的字段名： " + fieldError.getField());
				System.out.println(" 错误信息： " + fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
		
	}
	
	/*
	 * @ResponseBody 需要导入包
	 * param pn
	 * 返回 json 数据
	 * */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn", defaultValue="1")Integer pn,Model model) {
		//这不是一个分页查询
		// 引入 PageHelper
		//在查询之前只需要调用,传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage 后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		
		//使用 PageInfo 包装查询后的结果，只需要将 PageInfo 交给页面就行了
		//封装了详细的分页信息，包含有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		//model.addAttribute("pageInfo", page);
		return Msg.success().add("pageInfo" , page);
	}
	
	
	/**
	 *  查询员工数据（分页查询）
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn", defaultValue="1")Integer pn,Model model) {
		//这不是一个分页查询
		// 引入 PageHelper
		//在查询之前只需要调用,传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage 后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		
		//使用 PageInfo 包装查询后的结果，只需要将 PageInfo 交给页面就行了
		//封装了详细的分页信息，包含有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
