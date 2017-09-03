<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
	<%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
        String path = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort() + request.getContextPath()
                + "/";
        System.out.println(path);
		System.out.println("APP_PATH = " + pageContext.getAttribute("APP_PATH"));
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<!-- 写成这样会报错 <%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%> -->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>员工列表</title>
	<!-- 不以/开始的相对路径，找资源，以当前资源的路径为基准，容易出问题
		以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）,需要加上项目名称
		http://localhost:3306/crud 
	-->
	<!-- 引入 JQuery -->
	<script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.2.1.js"></script>
	<!-- 引入 BootStrap css 样式-->
	<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- 引入 JS -->
	<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 员工添加模态框 -->
	<!-- Modal -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			 <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			 <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked> 男
				  </label>
				  <label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
			      </label>
			    </div>
			  </div>
			  
			   <div class="form-group">
			   	 <label class="col-sm-2 control-label">deptName</label>
			   	 <div class="col-sm-4">
			    	<select class="form-control" name="dId" id="dept_add_select">
						
					</select>
			   	 </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 员工修改模态框 -->
	<!-- Modal -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">员工修改</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			        <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			 <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			 <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M" checked> 男
				  </label>
				  <label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
			      </label>
			    </div>
			  </div>
			  
			   <div class="form-group">
			   	 <label class="col-sm-2 control-label">deptName</label>
			   	 <div class="col-sm-4">
			    	<select class="form-control" name="dId">
						
					</select>
			   	 </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
	      </div>
	    </div>
	  </div>
	</div>
	

	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-primary btn-sm" id="emp_add_modal_btn">新增</button>
				<button type="button" class="btn btn-danger btn-sm" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class=col-md-12>
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all" />
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>department</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页信息栏 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div id="page_info_area" class="col-md-6">
				
			</div>
			
			<!-- 分页条信息 -->
			<div id="page_nav_area" class="col-md-6">
				
			</div>
		</div>
	</div>
	<script type="text/javascript">
		
		var totalRecord, currentPage;
		//1、页面加载完成以后，直接去发送一个 ajax 请求，要到分页数据,$表示页面加载完再执行这个函数
		$(function(){
			to_page(1);
		});
		
		function to_page(pn) {
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"GET",
				success:function(result){
					//解析数据，显示数据
					build_emps_table(result);	
					//显示分页信息
					build_page_info(result);
					//添加分页条
					build_page_nav(result);
				}
			});
		}
		
		//显示员工信息
		function build_emps_table(result) {
			//清空数据
			$("#emps_table tbody").empty();
			
			var emps = result.extend.pageInfo.list;
	
			$.each(emps, function(index, item) {
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				
				var genderTd = $("<td></td>").append(item.gender=='M'?'男':'女');
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department.deptName);
				/*
				<button type="button" class="">新增</button>
				<button type="button" class="btn btn-danger btn-sm">删除</button>
				<span class="" aria-hidden="true"></span>
				*/
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append($("<span></span>"))
				.addClass("glyphicon glyphicon-pencil").append("编辑");
				editBtn.attr("edit-id", item.empId);
				
				
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>"))
				.addClass("glyphicon glyphicon-trash").append("删除");
				delBtn.attr("del-id", item.empId);
				
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				$("<tr></tr>").append(checkBoxTd)
				.append(empIdTd)
				.append(empNameTd)
				.append(genderTd)
				.append(emailTd)
				.append(deptNameTd)
				.append(btnTd)
				.appendTo("#emps_table tbody");
				
			});
		}
		
		//显示分页信息
		function build_page_info(result) {
			//清空数据
			$("#page_info_area").empty();
			//alert("hello");
			$("#page_info_area").append("当前 " + 
					result.extend.pageInfo.pageNum + " 页，总 " + 
					result.extend.pageInfo.pages + " 页，总 " + 	
					result.extend.pageInfo.total + " 条记录");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		
		//显示导航条
		function build_page_nav(result) {
			//清空数据
			$("#page_nav_area").empty();
			//page_nav_area
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else {
				//添加首页、前一页的点击
				firstPageLi.click(function() {
					to_page(1);
				});
				
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}
			

			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			
			if(result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				//添加末页、下一页的点击
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
			}
			

			
			ul.append(firstPageLi).append(prePageLi);
			
			$.each(result.extend.pageInfo.navigatepageNums,function(index, item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if(result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				
				numLi.click(function(){
					to_page(item);	
				});
				
				ul.append(numLi);
			});
			ul.append(nextPageLi).append(lastPageLi);
			
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
	
		function reset_form(ele) {
			$(ele)[0].reset();
			$(ele).find("*").removeClass("has-error");
			$(ele).find(".help-block").text("");
		}
		
		$("#emp_add_modal_btn").click(function() {
			reset_form("#empAddModal form");
			
			//发送 ajax 请求， 查出部门信息，显示在下拉框中
			getDepts("#empAddModal select");
			
			//弹出模态框
			$("#empAddModal").modal({
				backdrop:"static"
			});
		});
		
		//查出所有部门信息
		function getDepts(ele) {
			$(ele).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result) {
					//console.log(result);
					//$("#dept_add_select")
					//$("#empAddModal select").append("")
					$.each(result.extend.depts,function() {
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});	
		}
		
		//校验表单数据
		function validate_add_form() {
			//拿到要校验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)) {
				show_validate_msg("#empName_add_input", "error", "用户名可以是 2-5 位中文或者6-16位英文和数字、-、_、的组合");
				return false;
			}else {
				show_validate_msg("#empName_add_input", "success", "");
			}
			
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)) {
				//alert("邮箱格式不正确");
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
			/* 	$("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next("span").text("邮箱格式不正确"); */
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
				/* $("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next("span").text(""); */
			}
			
			return true;
		}
		
		function show_validate_msg(ele, status, msg) {
			//清除状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if("success"==status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error"==status){
				//alert("用户名可以是 2-5 位中文或者6-16位英文和数字、-、_、的组合");
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		$("#empName_add_input").change(function() {
			var empName = this.value;
			
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName="+empName,
				type:"POST",
				success:function(result) {
					if(result.code==100) {
						show_validate_msg("#empName_add_input","success",
								"用户名可用");
						$("#emp_save_btn").attr("ajax-va", "success");
					}else {
						show_validate_msg("#empName_add_input","error",
						result.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va", "error");
					}
				}
			});
		});
		
		$("#emp_save_btn").click(function(){
			/* if(!validate_add_form()) {
				return false;
			} */
			
			
			if($(this).attr("ajax-va") == "error") {
				return false;
			}
			
			//1、模态框中填写的表单数据提交给服务器
			//2、发送 Ajax 请求保存员工
			
			 $.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAddModal form").serialize(),
				success:function(result) {
					if(result.code == 100) {
						//alert(result.msg);
						//1. 关闭模态框
						$("#empAddModal").modal("hide");
						//2.来到最后一页
						//发送 ajax 显示最后一页的数据
						to_page(totalRecord);
					} else {
						//显示失败信息
						//console.log(result);
						
						//有哪个字段错误信息就返回哪一个
						if(undefined != result.extend.errorFields.email) {
							show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
						}
						if(undefined != result.extend.errorFields.empName) {
							show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
						}
					}
					
				}
			}); 
		});
		
	
		//我们是按钮，
		$(document).on("click", ".edit_btn",function() {
			//alert("edit");
			//弹出模态框
			
			getDepts("#empUpdateModal select");
			//alert($(this).attr("edit-id"));
			getEmp($(this).attr("edit-id"));
			
			//把员工 的 id 传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
			$("#empUpdateModal").modal({
				backdrop:"static"
			});
			
		});
		
		function getEmp(id) {
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type: "GET",
				success: function(result) {
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empUpdateModalinput[name=gender]").val([empData.gender]);
					$("#empUpdateModal select").val([empData.dId]);
				}
			});
		}
		
		//点击更新，更新员工信息
		$("#emp_update_btn").click(function() {
			//验证邮箱
			var email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)) {
				show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
				return false;
			} else {
				show_validate_msg("#email_update_input", "success", "");
			}
			
			//发送 ajax 请求
			$.ajax({
				url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
				type: "PUT",
				data:$("#empUpdateModal form").serialize(),
				success:function(result) {
					//alert(result.msg);
					$("#empUpdateModal").modal("hide");
					to_page(currentPage);
				}
			});
		});
		
		//单个删除
		$(document).on("click",".delete_btn", function(){
				var empName = $(this).parents("tr").find("td:eq(2)").text();
				var empId = $(this).attr("del-id");
				if(confirm("确认删除【" + empName + "】吗?")) {
					//确认，发送 Ajax
					$.ajax({
						url: "${APP_PATH}/emp/" + empId,
						type: "DELETE",
						success: function(result) {
							alert(result.msg);
							//回到本页
							to_page(currentPage);
						}
					});
				}
		});
		
		$("#check_all").click(function() {
			$(".check_item").prop("checked", $(this).prop("checked"));
		});
		
		$(document).on("click",".check_item", function() {
		var flag = $(".check_item:checked").length == $(".check_item").length;
		$("#check_all").prop("checked", flag);
		});
		
		
		//点击全部删除，就批量删除
		$("#emp_delete_all_btn").click(function() {
			var empNames = "";
			var del_idstr = "";
			$.each($(".check_item:checked"), function() {
				empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
				del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
			});
			empNames = empNames.substring(0, empNames.length - 1);
			del_idstr = del_idstr.substring(0, del_idstr.length - 1);
			if(confirm("确认删除【" + empNames + "】吗?")) {
				$.ajax({
					url:"${APP_PATH}/emp/" + del_idstr,
					type:"DELETE",
					success:function(result) {
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
	</script>
</body>
</html>