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
	// WHERE절의 조건으로 사용할 회원 일련번호는 SESSION에 저장된 값을 사용해야 하므로, 세션의 데이터를 획득한다.
	Member loginInfo = (Member) session.getAttribute("member");
	
	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);

	String user_pw = helper.getString("user_pw");
	String new_user_pw = helper.getString("new_user_pw");
	String new_user_pw_re = helper.getString("new_user_pw_re");
	String user_name = helper.getString("user_name");
	String email = helper.getString("email");
	String tel = helper.getString("tel");
	String postcode = helper.getString("postcode");
	String addr1 = helper.getString("addr1");
	String addr2 = helper.getString("addr2");

	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());

	logger.debug("user_pw=" + user_pw);
	logger.debug("new_user_pw=" + new_user_pw);
	logger.debug("new_user_pw_re=" + new_user_pw_re);
	logger.debug("user_name=" + user_name);
	logger.debug("email=" + email);
	logger.debug("tel=" + tel);
	logger.debug("postcode=" + postcode);
	logger.debug("addr1=" + addr1);
	logger.debug("addr2=" + addr2);

	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();

	if (!regex.isValue(user_pw)) {
		helper.redirect(null, "현재 비밀번호를 입력하세요.");
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
	// 신규 비밀번호가 입력되었다면? --> 조건에 느낌표 없음
	if (regex.isValue(new_user_pw)) {
		// 신규 비밀번호와 확인값을 비교한다.
		if (!new_user_pw.equals(new_user_pw_re)) {
			helper.redirect(null, "비밀번호 확인이 잘못되었습니다.");
			return;
		}
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
	// 수정 대상이 아닌 정보는 Session에서 획득한 값을 넣어준다.
	Member member = new Member(loginInfo.getId(), null, user_pw, user_name, email, tel, postcode, addr1, addr2, null, null);
	
	// 비밀번호 변경을 위해서 새 비밀번호를 입력했다면, Beans에 별도로 설정한다.
	if (new_user_pw != null) {
		member.setNewUserPw(new_user_pw);
	}

	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();

	/** DAO를 활용한 UPDATE 처리 */
	// 변경된 데이터의 수를 저장할 변수
	int result = 0;

	try {
		// 회원 정보 변경을 위한 UPDATE 기능 호출하기
		result = sqlSession.update("MemberMapper.doEdit", member);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 페이지 종료 전에 입력사항을 저장(commit)만 한다.
		// 접속을 해제하지 않는 이유는 변경된 정보로 세션을 갱신하기 위해
		//  다시 한번 회원 정보를 조회해야 하기 때문이다.
		sqlSession.commit();
	}

	// UPDATE에 실패했다면 AUTO_INCREMENT가 생성되지 않기 때문에 0이다.
	if (result < 1) {
		// 하지만 에러가 발생했다면 접속을 해제시킨다.
		sqlSession.close();
		helper.redirect(null, "현재 비밀번호가 맞지 않습니다.");
		return;
	}
	
	/** 회원 정보가 변경되었으므로, 세션 데이터를 갱신하기 위해서 조회된 데이터를 가져온다. */
	Member editInfo = null;
	try {
		// 세션에 저장되어 있는 회원 일련번호를 활용하여 회원정보 조회하기 
		editInfo = sqlSession.selectOne("MemberMapper.getInfo", loginInfo.getId());
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 페이지 종료 전에 접속을 해제한다.
		sqlSession.close();
	}
	
	if (editInfo == null) {
		helper.redirect(null, "변경된 정보를 조회하는데 실패했습니다.");
		return;
	}
	
	// 기존의 세션 삭제
	session.removeAttribute("member");
	// 수정된 데이터를 담고 있는 Beans를 세션에 새로 등록
	session.setAttribute("member", editInfo);

	/** 다시 첫 페이지로 이동한다. */
	String url = "../index.jsp";
	helper.redirect(url, "회원 정보가 변경되었습니다.");
%>
