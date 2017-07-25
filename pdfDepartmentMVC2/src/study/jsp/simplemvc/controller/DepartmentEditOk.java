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
		
		//이전 페이지에 대한 파라미터 받기
		int deptno = web.getInt("deptno");
		String dname = web.getString("dname");
		String loc = web.getString("loc");

		// 파라미터를 사용하여 데이터 Beans 생성하기
		Department department = new Department(deptno, dname, loc);

		// 데이터베이스 접속하기
		SqlSessionFactory sqlSessionFactory 
					= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();

		// DAO를 활용한 수정처리
		// --> DepartmentMapper라는 namespace를 갖는 XML에서
		//     id값이 update인 <update> 태그를 호출한다. 이 때, 수정할 내용이 
		//     저장된 Beans를 파라미터로 전달하고, 수정된 행의 수를 리턴받는다.
		int result = 0;

		try {
			result = sqlSession.update("DepartmentMapper.update", department);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		} finally {
			// 페이지 종료 전에 입력사항을 저장(commit)하고 데이터베이스 접속 해제
			sqlSession.commit();
			sqlSession.close();
		}
		
		// update에 실패했다면?
		if (result < 1) {
			web.redirect(null, "수정된 데이터가 없습니다.");
			return null;
		}
		
		// 읽기 페이지로 다시 이동 한다.
		String url = "department_view.do?deptno="  + deptno;
		web.redirect(url, "수정되었습니다.");
		
		return null;
	}

}
