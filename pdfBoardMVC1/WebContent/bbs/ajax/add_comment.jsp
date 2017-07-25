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
	/** 회원 일련번호를 획득하기 위해서 세션데이터 추출하기 */
	Member loginInfo = (Member) session.getAttribute("member");
	int member_id = 0;
	
	if (loginInfo != null) {
		member_id = loginInfo.getId();
	}

	/** WebHelper를 사용한 파라미터 처리 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	
	int document_id = helper.getInt("document_id");
	String writer_name = helper.getString("writer_name");
	String writer_pw = helper.getString("writer_pw");
	String email = helper.getString("email");
	String content = helper.getString("content");

	// 접속자의 IP주소
	String ip_address = request.getRemoteAddr();
	
	/** 로그인 중이라면 이름, 비번, 이메일은 세션정보에서 채워 넣는다. */
	if (loginInfo != null) {
		writer_name = loginInfo.getUserName();
		writer_pw = loginInfo.getUserPw();
		email = loginInfo.getEmail();
	}
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());

	logger.debug("document_id=" + document_id);
	logger.debug("writer_name=" + writer_name);
	logger.debug("writer_pw=" + writer_pw);
	logger.debug("email=" + email);
	logger.debug("content=" + content);
	logger.debug("ip_address=" + ip_address);
	
	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();

	if (document_id < 1) {
		helper.printJsonRt("게시물 일련번호가 없습니다.");
		return;
	}
	
	if (!regex.isValue(writer_name)) {
		helper.printJsonRt("작성자 이름을 입력하세요.");
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
	// --> 덧글 일련번호와 날짜는 0으로 설정한다.
	// --> 부모글의 일련번호(document_id)값을 전달해야 참조키 제약조건에 위배되지 않는다.
	// --> 회원 일련번호의 값에 따라서 Mapper에서 분기 처리가 수행된다.
	BBSComment comment = new BBSComment(0, document_id, member_id, writer_name, writer_pw, email, content, ip_address, null, null);

	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 게시물 데이터 저장하기 */
	// 저장 후 리턴받을 게시물 일련번호 
	int comment_id = 0;
	
	try {
		// 데이터 저장하기
		sqlSession.insert("BBSCommentMapper.doWrite", comment);
		// 새로 생성된 PK는 Beans에 설정된다.
		comment_id = comment.getId();
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	// 저장에 실패하였다면?
	if (comment_id < 1) {
		sqlSession.close();
		helper.printJsonRt("덧글 저장에 실패했습니다.");
		return;
	}
	
	/** 저장된 덧글 정보를 다시 조회한다. */
	BBSComment savedComment = null;
	
	try {
		// 특정 게시물 정보 조회하기
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
	
	/** DB Insert 결과 반영 및 접속 해제 */
	sqlSession.commit();
	sqlSession.close();
	
	/****** JSON 결과 출력하기 *******/
	JSONObject item_json = new JSONObject();
	
	// 내용의 줄바꿈 문자를 <br /> 태그로 변경한다.
	String content_replace = savedComment.getContent();
	content_replace = content_replace.replace("\n", "<br />");
	
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