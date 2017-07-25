<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.jsp.mysite.model.BBSComment"%>
<%@ page import="study.jsp.mysite.model.Member"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%
	/** 로그인 한 회원 정보를 얻는다. */
	int member_id = 0;
	Member myinfo = (Member) session.getAttribute("member");

	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	int comment_id = helper.getInt("comment_id");
	String pwd = helper.getString("pwd");
	// 자신의 덧글을 삭제하는지 여부 - 기본값은 N
	String is_mine = helper.getString("is_mine", "N");
	
	// 로그인 상태이고, 자신의 덧글을 삭제한다면?
	if (myinfo != null && is_mine.equals("Y")) {
		// 비밀번호를 세션의 정보로 사용한다.
		pwd = myinfo.getUserPw();
		// 세션에 저장된 회원 번호를 얻는다.
		member_id = myinfo.getId();
	}
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("comment_id=" + comment_id);
	logger.debug("pwd=" + pwd);
	logger.debug("is_mine=" + is_mine);
	
	/** 파라미터 검사 */
	RegexHelper regex = RegexHelper.getInstance();
	
	if (comment_id < 1) {
		helper.printJsonRt("덧글 일련번호가 없습니다.");
		return;
	}
	
	if (!regex.isValue(pwd)) {
		helper.printJsonRt("비밀번호를 입력하세요.");
		return;
	}
	
	/** 작성 내용을 Beans 객체로 구성 */
	// --> 덧글 일련번호와 비밀번호만 설정한다.
	BBSComment comment = new BBSComment(comment_id, 0, member_id, null, pwd, null, null, null, null, null);
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 비밀번호 검사하기 */
	if (is_mine.equals("N")) {
		// 자신의 덧글이 아닌 경우 수행한다.
		int password_check = 0;
		try {
			// 비밀번호 검사를 위한 Mapper 기능 호출
			password_check = sqlSession.selectOne(
								"BBSCommentMapper.checkPassword", comment);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (password_check < 1) {
			sqlSession.close();
			helper.printJsonRt("비밀번호가 맞지 않습니다.");
			return;
		}
	} else {
		// 비밀번호 검사 대신, 자신의 덧글이 맞는지 검사한다.
		try {
			comment = sqlSession.selectOne(
							"BBSCommentMapper.getCommentItem", comment_id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		// 조회결과가 있다면?
		if (comment != null) {
			// 덧글에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
			if (comment.getMemberId() != member_id) {
				sqlSession.close();
				helper.printJsonRt("직접 작성한 글이 아니므로 삭제할 수 없습니다.");
				return;
			}
		}
	}
	
	/** 덧글을 삭제한다. */
	int delete_count = 0;
	try {
		delete_count = sqlSession.delete(
						"BBSCommentMapper.doDelete", comment_id);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	if (delete_count < 1) {
		sqlSession.close();
		helper.printJsonRt("삭제된 덧글이 없습니다.");
		return;
	}
	
	/** 삭제 결과 반영 및 접속 해제 */
	sqlSession.commit();
	sqlSession.close();
	
	/** 결과 출력 --> 삭제는 특별히 출력할 내용이 없으므로 성공 결과값만 출력한다. */
	helper.printJsonRt("SUCCESS");
%>













