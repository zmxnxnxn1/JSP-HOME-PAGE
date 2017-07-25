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
	String user_pw_re = helper.getString("user_pw_re");
	String user_name = helper.getString("user_name");
	String email = helper.getString("email");
	String tel = helper.getString("tel");
	String postcode = helper.getString("postcode");
	String addr1 = helper.getString("addr1");
	String addr2 = helper.getString("addr2");

	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());

	logger.debug("user_id=" + user_id);
	logger.debug("user_pw=" + user_pw);
	logger.debug("user_pw_re=" + user_pw_re);
	logger.debug("user_name=" + user_name);
	logger.debug("email=" + email);
	logger.debug("tel=" + tel);
	logger.debug("postcode=" + postcode);
	logger.debug("addr1=" + addr1);
	logger.debug("addr2=" + addr2);

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

	if (!regex.isValue(user_pw_re)) {
		helper.redirect(null, "비밀번호 확인값을 입력하세요.");
		return;
	}

	if (!regex.isValue(user_name)) {
		helper.redirect(null, "이름을 입력하세요.");
		return;
	}

	if (!regex.isValue(email)) {
		helper.redirect(null, "이메일을 입력하세요.");
		return;
	}

	if (!regex.isValue(tel)) {
		helper.redirect(null, "연락처를 입력하세요.");
		return;
	}

	/** 비밀번호 확인 */
	if (!user_pw.equals(user_pw_re)) {
		helper.redirect(null, "비밀번호 확인값이 잘못되었습니다.");
		return;
	}

	/** 이메일 형식검사 */
	if (!regex.isEmail(email)) {
		helper.redirect(null, "이메일 형식이 잘못되었습니다.");
		return;
	}

	/** 연락처가 핸드폰 번호 형식인지 검사 */
	// '-'을 제거하고 RegexHelper에게 전달해야 한다.
	if (!regex.isCellPhone(tel.replace("-", ""))) {
		helper.redirect(null, "연락처가 핸드폰 형식이 아닙니다.");
		return;
	}

	/** 모든 검사를 완료 하였으므로, 데이터 저장을 위한 Beans 객체 생성 */
	Member member = new Member(0, user_id, user_pw, user_name, email,
			tel, postcode, addr1, addr2, null, null);

	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 아이디 중복검사 */
	int id_count = 0;
	try {
		// 데이터 조회결과 호출
		id_count = sqlSession.selectOne("MemberMapper.getUserIdCount", user_id);
	} catch(Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 아직 가입처리가 남아 있으므로, 접속을 종료하지 않는다.
	}
	
	// 조회결과가 0보다 크다면 중복된 아이디임
	if (id_count > 0) {
		// 처리를 종료해야 하므로 DB접속 해제
		sqlSession.close();
		helper.redirect(null, "이미 사용중인 아이디 입니다.");
		return;
	}
	
	/** 이메일 중복검사 */
	int email_count = 0;
	try {
		// 데이터 조회결과 호출
		email_count = sqlSession.selectOne("MemberMapper.getEmailCount", email);
	} catch(Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 아직 가입처리가 남아 있으므로, 접속을 종료하지 않는다.
	}
	
	// 조회결과가 0보다 크다면 중복된 아이디임
	if (email_count > 0) {
		// 처리를 종료해야 하므로 DB접속 해제
		sqlSession.close();
		helper.redirect(null, "이미 사용중인 이메일 입니다.");
		return;
	}
	

	/** DAO를 활용한 입력값 저장처리 */
	// 생성된 회원 일련번호를 저장할 변수
	int member_id = 0;

	try {
		// 회원 가입을 위한 INSERT 기능 호출
		sqlSession.insert("MemberMapper.doJoin", member);
		// 생성된 PK는 Beans에 저장된다.
		member_id = member.getId();
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 페이지 종료 전에 입력사항을 저장(commit)하고 데이터베이스 접속 해제하기
		sqlSession.commit();
		sqlSession.close();
	}

	// INSERT에 실패했다면 AUTO_INCREMENT가 생성되지 않기 때문에 0이다.
	if (member_id < 1) {
		helper.redirect(null, "회원가입에 실패했습니다. 관리자에게 문의 바랍니다.");
		return;
	}

	/** 다시 첫 페이지로 이동한다. */
	String url = "../index.jsp";
	helper.redirect(url, "회원 가입을 축하합니다. 로그인 해 주세요.");
%>













