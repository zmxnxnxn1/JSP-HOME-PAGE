package study.jsp.simplemvc.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import study.java.helper.BaseController;
import study.java.helper.PageHelper;
import study.java.helper.WebHelper;
import study.jsp.simplemvc.model.Department;
import study.jsp.simplemvc.mybatis.MyBatisConnectionFactory;

@WebServlet("/department_list.do")
public class DepartmentList extends BaseController {

	private static final long serialVersionUID = -8458592644423851832L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, 
			HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		// �˻� Ű���� �Ķ���� ó��
		String keyword = web.getString("keyword");
		
		// �˻�� Beans�� �����Ѵ�.
		Department dept = new Department();
		dept.setKeyword(keyword);
		
		// �����ͺ��̽� �����ϱ�
		SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		/** ������ ��ȣ �Ķ���� �ޱ� > �⺻���� 1�� �����Ѵ� */
		int now_page = web.getInt("page", 1);

		/** �Խù� �� ��ȸ�ϱ� */
		int total_count = 0;
		try {
			// ������ ��ȸ ��� ȣ��
			total_count = sqlSession.selectOne("DepartmentMapper.getCount", dept);
		} catch (Exception e) {
			// ������ �� ��� ó���� ������ �ִٸ� �����Ѵ�.
			logger.error(e.getMessage());
		}
		
		/** ������ ������ �ʿ��� ���������� ����Ѵ�. */
		PageHelper pageHelper = PageHelper.getInstance(now_page, total_count, 10, 5);
		logger.debug(pageHelper.toString());
		
		// ������ ���� ���ۿ��� ���� �� �߿��� Limit ���� ���� Beans�� �����Ѵ�.
		dept.setLimitStart(pageHelper.getLimitStart());
		dept.setListCount(pageHelper.getListCount());

		// ������ ��ȸ�ϱ� --> DepartmentMapper��� namespace�� ���� XML���� 
		// id���� select�� <select> �±׸� ȣ���Ѵ�.
		List<Department> list = null;

		try {
			list = sqlSession.selectList("DepartmentMapper.select", dept);
		} catch (Exception e) {
			// ������ �� ��� ó���� ������ �ִٸ� �����Ѵ�.
			logger.error(e.getMessage());
		} finally {
			// ������ ���� ���� �����ͺ��̽� ���� �����ϱ�
			sqlSession.close();
		}
		
		// ��ȸ�� �����ߴٸ� list�� ������ null�̴�.
		if (list == null) {
			web.redirect(null, "����� �����Ͱ� �����ϴ�.");
			return null;
		}
		
		// ��ȸ �����͸� request��ü�� �߰��Ѵ�.
		request.setAttribute("dept_list", list);
		// �˻�� request��ü�� �߰��Ѵ�.
		request.setAttribute("keyword", keyword);
		// ������ ��ȣ ������ request ��ü�� �߰��Ѵ�.
		request.setAttribute("page_helper", pageHelper);
		// ���� �������� request ��ü�� �߰��Ѵ�.
		request.setAttribute("now_page", now_page);
		
		// ����� View �̸��� �����Ѵ�.
		return "department_list";
	}

}
