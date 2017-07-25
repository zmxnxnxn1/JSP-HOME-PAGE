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

@WebServlet("/department_edit_ok.do")
public class DepartmentEditOk extends BaseController {
	private static final long serialVersionUID = 2924184532928805388L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		//���� �������� ���� �Ķ���� �ޱ�
		int deptno = web.getInt("deptno");
		String dname = web.getString("dname");
		String loc = web.getString("loc");

		// �Ķ���͸� ����Ͽ� ������ Beans �����ϱ�
		Department department = new Department(deptno, dname, loc);

		// �����ͺ��̽� �����ϱ�
		SqlSessionFactory sqlSessionFactory 
					= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();

		// DAO�� Ȱ���� ����ó��
		// --> DepartmentMapper��� namespace�� ���� XML����
		//     id���� update�� <update> �±׸� ȣ���Ѵ�. �� ��, ������ ������ 
		//     ����� Beans�� �Ķ���ͷ� �����ϰ�, ������ ���� ���� ���Ϲ޴´�.
		int result = 0;

		try {
			result = sqlSession.update("DepartmentMapper.update", department);
		} catch (Exception e) {
			// ������ �� ��� ó���� ������ �ִٸ� �����Ѵ�.
		} finally {
			// ������ ���� ���� �Է»����� ����(commit)�ϰ� �����ͺ��̽� ���� ����
			sqlSession.commit();
			sqlSession.close();
		}
		
		// update�� �����ߴٸ�?
		if (result < 1) {
			web.redirect(null, "������ �����Ͱ� �����ϴ�.");
			return null;
		}
		
		// �б� �������� �ٽ� �̵� �Ѵ�.
		String url = "department_view.do?deptno="  + deptno;
		web.redirect(url, "�����Ǿ����ϴ�.");
		
		return null;
	}

}
