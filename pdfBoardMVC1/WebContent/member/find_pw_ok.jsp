<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.MailHelper"%>
<%@ page import="study.java.helper.Util"%>
<%@ page import="study.jsp.mysite.model.Member"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>

<%
	// 헬퍼 객체 생성
	WebHelper helper = WebHelper.getInstance(request, response, out);
	String email = helper.getString("email");
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("email=" + email);
	
	// 입력여부 검사후, 입력되지 않은 경우 이전 페이지로 보내기
	if (email == null) {
		helper.redirect(null, "이메일 주소를 입력하셔야 합니다.");
		return;
	}
	
	// 임시 비밀번호로 사용하기 위한 랜덤한 값을 얻는다.
	int randnum = Util.getInstance().random(10000, 99999);
	// Beans가 비밀번호를 String으로 설정하고 있으므로, 숫자값을 문자열로 변환한다.
	String new_password = String.valueOf(randnum);
	
	// 이메일과 새 비밀번호를 저장하는 Beans 생성하기
	Member member = new Member(0, null, new_password, null, email, null, null, null, null, null, null);
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();

	/** 비밀번호 변경 수행 */
	int result = 0;

	try {
		// UPDATE 기능 호출하기 --> 수정된 행의 수가 리턴된다.
		result = sqlSession.update("MemberMapper.changePasswordByEmail", member);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 수정된 결과를 반영하고 데이터베이스 접속 해제하기
		sqlSession.commit();
		sqlSession.close();
	}

	// 수정된 행이 없다면 WHERE절의 조건으로 사용하는 이메일 주소가 없다는 의미
	if (result < 1) {
		helper.redirect(null, "입력된 이메일로 가입된 아이디가 존재하지 않습니다.");
		return;
	}
	
	/** 비밀번호 변경 안내 메일 발송하기 */
	MailHelper mail = MailHelper.getInstance();
	String sender = "zmxnxnxn1@naver.com";
	String subject = "임시 비밀번호 안내 메일 입니다.";
	String content = String.format("임시 비밀번호는 [%s] 입니다.", new_password);
	
	// 메일 발송하기
	boolean is_send = mail.sendMail(sender, email, subject, content);

	if (!is_send) {
		helper.redirect(null, "입력된 이메일로 가입된 아이디가 존재하지 않습니다.");
		return;
	}
	    
	helper.redirect("../index.jsp", "메일 발송에 성공했습니다.");
%>