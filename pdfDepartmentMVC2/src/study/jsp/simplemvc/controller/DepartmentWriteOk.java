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

@WebServlet("/department_write_ok.do")
public class DepartmentWriteOk extends BaseController {
	private static final long serialVersionUID = 1668611818902213835L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, 
			HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		//���� �������� ���� �Ķ���� �ޱ�
		String dname = web.getString("dname");
		String loc = web.getString("loc");

		// �Ķ���͸� ����Ͽ� ������ Beans �����ϱ�
		// --> INSERT���� deptno�� ������� �����Ƿ� 0���� ó���Ѵ�.
		Department department = new Department(0, dname, loc);

		// �����ͺ��̽� �����ϱ�
		SqlSessionFactory sqlSessionFactory 
							= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// DAO�� Ȱ���� �Է°� ����ó��
		// --> DepartmentMapper��� namespace�� ���� XML����
		//     id���� insert�� <insert> �±׸� ȣ���Ѵ�.
		//	   �� ��, ������ �����͸� ��� �ִ� Beans�� �Ķ���ͷ� �����ϰ�, 
		//     �ڵ����� ������ PK���� ���Ϲ޴´�.  
		int deptno = 0;

		try {
			sqlSession.insert("DepartmentMapper.insert", department);
			// ������ PK�� Beans�� ����ȴ�.
			deptno = department.getDeptno();
		} catch (Exception e) {
			// ������ �� ��� ó���� ������ �ִٸ� �����Ѵ�.
		} finally {
			// ������ ���� ���� �Է»����� ����(commit)�ϰ� �����ͺ��̽� ���� �����ϱ�
			sqlSession.commit();
			sqlSession.close();
		}
		
		// INSERT�� �����ߴٸ� AUTO_INCREMENT�� �������� �ʱ� ������ 0�̴�.
		if (deptno < 1) {
			web.redirect(null, "����� �����Ͱ� �����ϴ�.");
			return null;
		}
		
		// �б� �������� �̵��Ѵ�.
		String url = "department_view.do?deptno="  + deptno;
		web.redirect(url, "����Ǿ����ϴ�.");
		
		// View�� �����ִ� ���°� �ƴ϶�, �б� �������� �̵��ؾ� �ϹǷ�
		// View�� �̸��� �������� �ʴ´�.
		return null;
	}

}
