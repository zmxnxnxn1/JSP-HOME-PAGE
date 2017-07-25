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
		//이전 페이지에 대한 파라미터 받기
		String dname = web.getString("dname");
		String loc = web.getString("loc");

		// 파라미터를 사용하여 데이터 Beans 생성하기
		// --> INSERT에서 deptno는 사용하지 않으므로 0으로 처리한다.
		Department department = new Department(0, dname, loc);

		// 데이터베이스 접속하기
		SqlSessionFactory sqlSessionFactory 
							= MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		// DAO를 활용한 입력값 저장처리
		// --> DepartmentMapper라는 namespace를 갖는 XML에서
		//     id값이 insert인 <insert> 태그를 호출한다.
		//	   이 때, 저장할 데이터를 담고 있는 Beans를 파라미터로 전달하고, 
		//     자동으로 생성된 PK값을 리턴받는다.  
		int deptno = 0;

		try {
			sqlSession.insert("DepartmentMapper.insert", department);
			// 생성된 PK는 Beans에 저장된다.
			deptno = department.getDeptno();
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		} finally {
			// 페이지 종료 전에 입력사항을 저장(commit)하고 데이터베이스 접속 해제하기
			sqlSession.commit();
			sqlSession.close();
		}
		
		// INSERT에 실패했다면 AUTO_INCREMENT가 생성되지 않기 때문에 0이다.
		if (deptno < 1) {
			web.redirect(null, "저장된 데이터가 없습니다.");
			return null;
		}
		
		// 읽기 페이지로 이동한다.
		String url = "department_view.do?deptno="  + deptno;
		web.redirect(url, "저장되었습니다.");
		
		// View를 보여주는 형태가 아니라, 읽기 페이지로 이동해야 하므로
		// View의 이름을 리턴하지 않는다.
		return null;
	}

}
