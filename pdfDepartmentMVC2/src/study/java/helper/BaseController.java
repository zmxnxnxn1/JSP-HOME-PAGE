package study.java.helper;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

// --> URL�� ����Ǵ� @WebServlt�� �ڽ� Ŭ�������� �����ϵ��� �ϰ�, �� Ŭ������ �߻�Ŭ������ �����Ѵ�.
//@WebServlet("/BaseController")
public abstract class BaseController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// Log4j ��ü ����
	// --> import org.apache.logging.log4j.Logger;
	public Logger logger = null;
       
    public BaseController() {
        // ����Ǵ� ��ü�� Ȯ���ϱ� ���ؼ� Ŭ���� �̸��� �ֿܼ� ����Ѵ�.
    	String className = this.getClass().getName();
    	//System.out.println(className);
    	
    	// import org.apache.logging.log4j.LogManager;
    	logger = LogManager.getLogger(className);
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// ���� ó�� �޼���� ��� �̵���Ų��.
		this.pageInit(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// ���� ó�� �޼���� ��� �̵���Ų��.
		this.pageInit(request, response);
	}
	
	
	/**
	 * Get, Post ��Ŀ� ������� ���� ó���Ǵ� �޼���
	 * @param request		- JSP request ���� ��ü
	 * @param response		- JSP response ���� ��ü
	 */
	private void pageInit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// �������� ���޵Ǵ� �������� ���� ����
		response.setContentType("text/html; charset=utf-8");
		// �������κ��� ���޹޴� �Ķ������ ���ڵ� ���� ����
		request.setCharacterEncoding("utf-8");
		
		// ���� URL�� ȹ���ؼ� �α׿� ����Ѵ�.
		String url = request.getRequestURL().toString();
		if (request.getQueryString() != null) {
			url = url + "?" + request.getQueryString();
		}
		
		// GET�������, POST������� ��ȸ�Ѵ�.
		String methodName = request.getMethod();
		logger.info("[" + methodName + "]" + url);
		
		// WebHelper ��ü�� �����Ѵ�.
		PrintWriter out = response.getWriter();
		WebHelper web = WebHelper.getInstance(request, response, out);
		
		// View�� �̸��� ��� ���Ͽ� webPage �޼��带 ȣ���Ѵ�.
		String view = doRun(web, request, response, out);
		
		// ȹ���� View�� �����Ѵٸ� ȭ�� ǥ��
		if (view != null) {
			// View�� �����Ѵ�.
			view = "/WEB-INF/" + view + ".jsp";
			logger.info("[View] " + view);
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);
		}
	}
	
	/** 
	 * �� ������ ������ �ʿ��� ó���� ������ ��, View�� �̸��� �����Ѵ�.
	 * �� �޼��带 �߻�ȭ �Ѵ�.
	 * �� Ŭ������ ��ӹ޴� �ڽ� Ŭ������ �ݵ�� �� �޼��带 ������ �ؾ� �Ѵ�. 
	 */
	public abstract String doRun(WebHelper web, HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException;

}
