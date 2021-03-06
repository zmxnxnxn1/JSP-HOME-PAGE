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

@WebServlet("/department_view.do")
public class DepartmentView extends BaseController {

	private static final long serialVersionUID = -7867947540713526423L;

	@Override
	public String doRun(WebHelper web, HttpServletRequest request, 
			HttpServletResponse response, PrintWriter out)
			throws ServletException, IOException {
		
		// 학과 번호에 대한 파라미터 받기
		int deptno = web.getInt("deptno");

		// 데이터베이스 접속하기
		SqlSessionFactory sqlSessionFactory 
						= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// 데이터 조회
		Department department = null;

		try {
			department = sqlSession.selectOne(
									"DepartmentMapper.selectOne", deptno);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
			logger.error(e.getMessage());
		} finally {
			// 페이지 종료 전에 데이터베이스 접속 해제하기
			sqlSession.close();
		}
		
		// 조회된 데이터가 없다면 selectOne은 null을 리턴한다.
		// --> 메시지 출력 후, 이전 페이지로 이동처리
		if (department == null) {
			web.redirect(null, "조회된 데이터가 없습니다.");
			return null;
		}
		
		// 조회 결과를 request 객체에 등록하기
		request.setAttribute("department", department);
		
		// 읽기 처리를 담당하는 View의 이름을 리턴한다.
		return "department_view";
	}

}
