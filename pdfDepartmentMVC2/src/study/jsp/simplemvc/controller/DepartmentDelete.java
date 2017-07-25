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
		
		// 이전 페이지에 대한 파라미터 받기
		int deptno = web.getInt("deptno");

		// 데이터베이스 접속하기
		SqlSessionFactory sqlSessionFactory 
				= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// DAO를 활용한 삭제처리
		// --> DepartmentMapper라는 namespace를 갖는 XML에서
		//     id값이 delete인 <delete> 태그를 호출한다.
		//	   이 때, 삭제된 행의 수를 리턴받는다. 
		int result = 0;

		try {
			result = sqlSession.delete("DepartmentMapper.delete", deptno);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		} finally {
			// 페이지 종료 전에 입력사항을 저장(commit)하고
			// 데이터베이스 접속 해제하기
			sqlSession.commit();
			sqlSession.close();
		}
		
		// DELETE에 실패했다면 영향을 받은 행 수가 없으므로, 0이 리턴된다.
		if (result < 1) {
			web.redirect(null, "삭제된 데이터가 없습니다.");
			return null;
		}
		
		// DELETE 처리 후에는 읽고 있던 대상이 사라진 후 이므로, 목록으로 이동.
		String url = "department_list.do";
		web.redirect(url, "삭제되었습니다.");
		
		return null;
	}

}
