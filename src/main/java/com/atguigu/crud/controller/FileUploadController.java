package com.atguigu.crud.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.atguigu.crud.bean.User;


/**
 * 处理文件上传和下载的控制器
 * @author cjc
 *
 */
@Controller
public class FileUploadController {
	//处理请求，不想看到直接显示 jsp 后缀名
	@RequestMapping("/index2")
	public String index() {
		return "list";
	}
	
	//处理请求，跳到 SSM-CRUD （SSM-增删改查）的例子不想看到直接显示 jsp 后缀名
	@RequestMapping("/index1")
	public String index1() {
		return "list";
	}
	
	//处理表单请求，不想看到直接显示 jsp 后缀名
	//uploadForm registerForm download
	@RequestMapping("/{forName}")
	public String uploadForm(@PathVariable("forName")String forName) {
		System.out.println(forName);
		return forName;
	}
	
	
	//上传文件,common fileupload 包 
	@RequestMapping(value="/upload", method=RequestMethod.POST)
	public String upload(HttpServletRequest request, 
			@RequestParam("description")String description,
			@RequestParam("file")MultipartFile file) throws IllegalStateException, IOException {
		System.out.println(description);
		
		//如果文件不为空，写入上传路径
		if(!file.isEmpty()) {
			//上传文件路径
			String path = request.getServletContext().getRealPath("/images/");
			//上传文件名
			System.out.println(path);
			String filename = file.getOriginalFilename();
			File filepath = new File(path, filename);
			//判断路径是否存在，如果不存在就创建一个
			if(!filepath.getParentFile().exists()) {
				filepath.getParentFile().mkdirs();
			}
			//将上传文件保存到一个目标文件当中
			file.transferTo(new File(path + File.separator + filename));
			return "success";
		} else {
			return "error";
		}
	}
	
	/*ServletFileUpload 使用 servlet 的方法必须注释掉
	 * org.springframework.web.multipart.commons.CommonsMultipartResolver
	 * 的配置才能成功！
	 * */
	/*@RequestMapping(value="/upload1", method=RequestMethod.POST)
	public String upload1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        System.out.println(isMultipart);
        if (isMultipart) {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            	
            try {
                List<FileItem> items = upload.parseRequest(request);
                Iterator<FileItem> iterator = items.iterator();
                System.out.println(items.size());
                while (iterator.hasNext()) {
                    FileItem item = (FileItem) iterator.next();
                    System.out.println(item);
                    if (!item.isFormField()) {
                        String fileName = item.getName();

                        String root = request.getServletContext().getRealPath("/");
                        File path = new File(root + "/uploads");
                        if (!path.exists()) {
                            boolean status = path.mkdirs();
                            System.out.println(status);
                        }

                        File uploadedFile = new File(path + "/" + fileName);
                        System.out.println(uploadedFile.getAbsolutePath());
                        item.write(uploadedFile);
                    }
                }
            } catch (FileUploadException e) {
            	System.out.println("hello");
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "success";
        }
        return "";
    }*/

	
	
  //将上传的文件传给 User 对象
  @RequestMapping(value="/register")
     public String register(HttpServletRequest request,
             @ModelAttribute User user,
             Model model) throws Exception {
        System.out.println(user.getUsername());
        //如果文件不为空，写入上传路径
        if(!user.getImage().isEmpty()) {
            //上传文件路径
            String path = request.getServletContext().getRealPath("/images/");
            //上传文件名
            String filename = user.getImage().getOriginalFilename();
            File filepath = new File(path,filename);
            //判断路径是否存在，如果不存在就创建一个
            if (!filepath.getParentFile().exists()) { 
                filepath.getParentFile().mkdirs();
            }
            //将上传文件保存到一个目标文件当中
            user.getImage().transferTo(new File(path + File.separator + filename));
            //将用户添加到model
            model.addAttribute("user", user);
            return "userInfo";
        } else {
            return "error";
        }
    }
  
     @RequestMapping(value="/download")
     public ResponseEntity<byte[]> download(HttpServletRequest request,
             @RequestParam("filename") String filename,
             Model model)throws Exception {
    	request.setCharacterEncoding("UTF-8");
    	System.out.println(request.getCharacterEncoding());
        //下载文件路径
        String path = request.getServletContext().getRealPath("/images/");
        System.out.println(request.getServletContext());
        System.out.println(request.getServletContext().getRealPath("/images/"));
        File file = new File(path + File.separator + filename);
        HttpHeaders headers = new HttpHeaders();  
        //下载显示的文件名，解决中文名称乱码问题  
        String downloadFielName = new String(filename.getBytes("UTF-8"),"iso-8859-1");
        //通知浏览器以attachment（下载方式）打开图片
        headers.setContentDispositionFormData("attachment", downloadFielName); 
        //application/octet-stream ： 二进制流数据（最常见的文件下载）。
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(file),    
                headers, HttpStatus.CREATED);  
     }
}
