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
import study.jsp.simplemvc.mybatis.MyBatisConnectionFactory;

@WebServlet("/department_delete.do")
public class DepartmentDelete extends BaseController {
	private static final long serialVersionUID = -3672289073206163177L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		// ���� �������� ���� �Ķ���� �ޱ�
		int deptno = web.getInt("deptno");

		// �����ͺ��̽� �����ϱ�
		SqlSessionFactory sqlSessionFactory 
				= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// DAO�� Ȱ���� ����ó��
		// --> DepartmentMapper��� namespace�� ���� XML����
		//     id���� delete�� <delete> �±׸� ȣ���Ѵ�.
		//	   �� ��, ������ ���� ���� ���Ϲ޴´�. 
		int result = 0;

		try {
			result = sqlSession.delete("DepartmentMapper.delete", deptno);
		} catch (Exception e) {
			// ������ �� ��� ó���� ������ �ִٸ� �����Ѵ�.
		} finally {
			// ������ ���� ���� �Է»����� ����(commit)�ϰ�
			// �����ͺ��̽� ���� �����ϱ�
			sqlSession.commit();
			sqlSession.close();
		}
		
		// DELETE�� �����ߴٸ� ������ ���� �� ���� �����Ƿ�, 0�� ���ϵȴ�.
		if (result < 1) {
			web.redirect(null, "������ �����Ͱ� �����ϴ�.");
			return null;
		}
		
		// DELETE ó�� �Ŀ��� �а� �ִ� ����� ����� �� �̹Ƿ�, ������� �̵�.
		String url = "department_list.do";
		web.redirect(url, "�����Ǿ����ϴ�.");
		
		return null;
	}

}
