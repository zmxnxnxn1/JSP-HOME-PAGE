<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="org.json.JSONObject"%>
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
	String writer_name = helper.getString("writer_name");
	String writer_pw = helper.getString("writer_pw");
	String email = helper.getString("email");
	String content = helper.getString("content");
	// 접속자의 IP주소
	String ip_address = request.getRemoteAddr();
	// 자신의 덧글을 삭제하는지 여부 - 기본값은 N
	String is_mine = helper.getString("is_mine", "N");
	
	// 로그인 상태이고, 자신의 덧글을 삭제한다면?
	if (myinfo != null && is_mine.equals("Y")) {
		// 기본 정보를 세션의 정보로 사용한다.
		writer_name = myinfo.getUserName();
		writer_pw = myinfo.getUserPw();
		email = myinfo.getEmail();
		// 세션에 저장된 회원 번호를 얻는다.
		member_id = myinfo.getId();
	}
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("comment_id=" + comment_id);
	logger.debug("writer_name=" + writer_name);
	logger.debug("writer_pw=" + writer_pw);
	logger.debug("email=" + email);
	logger.debug("content=" + content);
	logger.debug("ip_address=" + ip_address);
	logger.debug("is_mine=" + is_mine);
	
	/** 파라미터 검사 */
	RegexHelper regex = RegexHelper.getInstance();
	
	if (comment_id < 1) {
		helper.printJsonRt("덧글 일련번호가 없습니다.");
		return;
	}
	
	if (!regex.isValue(writer_name)) {
		helper.printJsonRt("이름을 입력하세요.");
		return;
	}
	
	if (!regex.isValue(writer_pw)) {
		helper.printJsonRt("비밀번호를 입력하세요.");
		return;
	}
	
	if (!regex.isValue(email)) {
		helper.printJsonRt("이메일을 입력하세요.");
		return;
	}

	if (!regex.isEmail(email)) {
		helper.printJsonRt("이메일이 형식에 맞지 않습니다.");
		return;
	}
	
	if (!regex.isValue(content)) {
		helper.printJsonRt("내용을 입력하세요.");
		return;
	}
	
	/** 작성 내용을 Beans 객체로 구성 */
	// --> 덧글 일련번호와 비밀번호만 설정한다.
	BBSComment comment = new BBSComment(comment_id, 0, member_id, writer_name, writer_pw, email, content, ip_address, null, null);
	
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
		BBSComment nowComment = null;
		
		try {
			nowComment = sqlSession.selectOne(
							"BBSCommentMapper.getCommentItem", comment_id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		// 조회결과가 있다면?
		if (nowComment != null) {
			// 덧글에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
			if (nowComment.getMemberId() != member_id) {
				sqlSession.close();
				helper.printJsonRt("직접 작성한 글이 아니므로 삭제할 수 없습니다.");
				return;
			}
		}
	}
	
	/** 덧글을 수정한다. */
	int edit_count = 0;
	try {
		edit_count = sqlSession.update(
						"BBSCommentMapper.doEdit", comment);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	if (edit_count < 1) {
		sqlSession.close();
		helper.printJsonRt("수정된 덧글이 없습니다.");
		return;
	}
	
	/** 수정된 덧글 정보를 다시 조회한다. */
	BBSComment savedComment = null;
	
	try {
		savedComment = sqlSession.selectOne(
						"BBSCommentMapper.getCommentItem", comment_id);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}

	// 조회결과가 없다면?
	if (savedComment == null) {
		sqlSession.close();
		helper.printJsonRt("조회된 덧글이 없습니다.");
		return;
	}
	
	/** 수정 결과 반영 및 접속 해제 */
	sqlSession.commit();
	sqlSession.close();
	
	/****** JSON 결과 출력하기 > 덧글쓰기와 같은 처리 *******/
	JSONObject item_json = new JSONObject();
	
	// 내용의 줄바꿈 문자를 <br /> 태그로 변경한다.
	String content_replace = savedComment.getContent();
	content_replace = content_replace.replace("\n", "<br />");
	
	// 변경된 내용을 새롭게 JSON으로 구성한다.
	item_json.put("id", 				savedComment.getId());
	item_json.put("bbs_document_id", 	savedComment.getBbsDocumentId());
	item_json.put("writer_name", 		savedComment.getWriterName());
	item_json.put("writer_pw", 			savedComment.getWriterPw());
	item_json.put("email", 				savedComment.getEmail());
	item_json.put("content", 			content_replace);
	item_json.put("ip_address", 		savedComment.getIpAddress());
	item_json.put("reg_date", 			savedComment.getRegDate());
	item_json.put("edit_date", 			savedComment.getEditDate());
	
	JSONObject json = new JSONObject();
	json.put("rt", "SUCCESS");
	json.put("item", item_json);
	out.print(json.toString());
%>













