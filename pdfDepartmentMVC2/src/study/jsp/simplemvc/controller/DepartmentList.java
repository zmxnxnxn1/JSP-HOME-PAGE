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
		
		// 검색 키워드 파라미터 처리
		String keyword = web.getString("keyword");
		
		// 검색어를 Beans에 전달한다.
		Department dept = new Department();
		dept.setKeyword(keyword);
		
		// 데이터베이스 접속하기
		SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
		SqlSession sqlSession = sqlSessionFactory.openSession();
		
		/** 페이지 번호 파라미터 받기 > 기본값은 1로 설정한다 */
		int now_page = web.getInt("page", 1);

		/** 게시물 수 조회하기 */
		int total_count = 0;
		try {
			// 데이터 조회 결과 호출
			total_count = sqlSession.selectOne("DepartmentMapper.getCount", dept);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
			logger.error(e.getMessage());
		}
		
		/** 페이지 구현에 필요한 변수값들을 계산한다. */
		PageHelper pageHelper = PageHelper.getInstance(now_page, total_count, 10, 5);
		logger.debug(pageHelper.toString());
		
		// 페이지 구현 헬퍼에서 계산된 값 중에서 Limit 관련 값을 Beans에 설정한다.
		dept.setLimitStart(pageHelper.getLimitStart());
		dept.setListCount(pageHelper.getListCount());

		// 데이터 조회하기 --> DepartmentMapper라는 namespace를 갖는 XML에서 
		// id값이 select인 <select> 태그를 호출한다.
		List<Department> list = null;

		try {
			list = sqlSession.selectList("DepartmentMapper.select", dept);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
			logger.error(e.getMessage());
		} finally {
			// 페이지 종료 전에 데이터베이스 접속 해제하기
			sqlSession.close();
		}
		
		// 조회에 실패했다면 list는 여전히 null이다.
		if (list == null) {
			web.redirect(null, "저장된 데이터가 없습니다.");
			return null;
		}
		
		// 조회 데이터를 request객체에 추가한다.
		request.setAttribute("dept_list", list);
		// 검색어를 request객체에 추가한다.
		request.setAttribute("keyword", keyword);
		// 페이지 번호 정보를 request 객체에 추가한다.
		request.setAttribute("page_helper", pageHelper);
		// 현재 페이지를 request 객체에 추가한다.
		request.setAttribute("now_page", now_page);
		
		// 사용할 View 이름을 리턴한다.
		return "department_list";
	}

}
