<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.jsp.mysite.model.Member"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>

<%
	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	String user_id = helper.getString("user_id");
	String user_pw = helper.getString("user_pw");

	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("user_id=" + user_id);
	logger.debug("user_pw=" + user_pw);

	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();

	if (!regex.isValue(user_id)) {
		helper.redirect(null, "아이디를 입력하세요.");
		return;
	}

	if (!regex.isValue(user_pw)) {
		helper.redirect(null, "비밀번호를 입력하세요.");
		return;
	}

	/** 모든 검사를 완료 하였으므로, 데이터 조회를 위한 Beans 객체 생성 */
	// 객체 생성에 필요한 값을 제외하고는 0(숫자)이나 null(String)을 설정한다.
	Member member = new Member(0, user_id, user_pw, null, null, null, null, null, null, null, null);

	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();

	/** 로그인을 위한 데이터 조회 */
	Member result = null;

	try {
		// 아이디와 비밀번호가 일치하는 회원 정보 조회하기
		result = sqlSession.selectOne("MemberMapper.doLogin", member);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 데이터베이스 접속 해제하기
		sqlSession.close();
	}

	// 조회결과가 없다면 WHERE절의 조건이 잘못된 것이므로,
	// 아이디나 비밀번호가 잘못 입력된 경우.
	if (result == null) {
		helper.redirect(null, "아이디나 비밀번호가 맞지 않습니다.");
		return;
	}

	/** 로그인에 성공했으므로, 세션 생성후 다시 첫 페이지로 이동한다. */
	session.setAttribute("member", result);
	String url = "../index.jsp";
	helper.redirect(url, "안녕하세요. " + result.getUserName() + "님");
%>

