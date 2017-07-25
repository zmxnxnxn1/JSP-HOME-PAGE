package study.jsp.simplemvc.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import study.java.helper.BaseController;
import study.java.helper.WebHelper;

@WebServlet("/department_write.do")
public class DepartmentWrite extends BaseController {

	private static final long serialVersionUID = 4802060093694801046L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, 
			HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		// 특별한 데이터 연동 처리가 없으므로, view로 제어를 즉시 이동한다.
		return "department_write";
	}

}
