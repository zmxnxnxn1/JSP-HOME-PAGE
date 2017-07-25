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
		
		// Ư���� ������ ���� ó���� �����Ƿ�, view�� ��� ��� �̵��Ѵ�.
		return "department_write";
	}

}
