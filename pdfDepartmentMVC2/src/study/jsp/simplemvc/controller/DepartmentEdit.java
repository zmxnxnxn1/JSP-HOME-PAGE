package study.jsp.simplemvc.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import study.java.helper.BaseController;
import study.java.helper.WebHelper;
import study.jsp.simplemvc.model.Department;
import study.jsp.simplemvc.mybatis.MyBatisConnectionFactory;

@WebServlet("/department_edit.do")
public class DepartmentEdit extends BaseController {

	private static final long serialVersionUID = -4956248167601207305L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, 
			HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		// �а� ��ȣ�� ���� �Ķ���� �ޱ�
		int deptno = web.getInt("deptno");

		// �����ͺ��̽� �����ϱ�
		SqlSessionFactory sqlSessionFactory 
					= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// ������ ��ȸ
		Department department = null;

		try {
			department = sqlSession.selectOne("DepartmentMapper.selectOne", deptno);
		} catch (Exception e) {
			logger.error(e.getMessage());	// ������ �� ��� �α� ���
		} finally {
			sqlSession.close();	// ������ ���� ���� �����ͺ��̽� ���� �����ϱ�
		}
		
		// ��ȸ�� �����Ͱ� ���ٸ� --> �޽��� ��� ��, ���� �������� �̵�ó��
		if (department == null) {
			web.redirect(null, "��ȸ�� �����Ͱ� �����ϴ�.");
			return null;
		}
		
		// ��ȸ ����� View�� �����Ѵ�.
		request.setAttribute("department", department);
		
		// View�� �̸��� �����Ѵ�.
		return "department_edit";
	}
	
}
