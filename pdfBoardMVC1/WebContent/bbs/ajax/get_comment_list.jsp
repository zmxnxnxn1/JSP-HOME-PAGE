<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.jsp.mysite.model.BBSComment"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%
	/** 파라미터 처리 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	Logger logger = LogManager.getLogger(request.getRequestURI());
	
	int document_id = helper.getInt("document_id");
	logger.debug("document_id=" + document_id);
	
	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();

	if (document_id < 1) {
		helper.printJsonRt("게시물 일련번호가 없습니다.");
		return;
	}

	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 덧글 데이터 조회하기 */ 
	List<BBSComment> list = null;
	
	try {
		list = sqlSession.selectList("BBSCommentMapper.getCommentList", document_id);
	} catch (Exception e) {
		logger.error(e.getMessage());
	} finally {
		sqlSession.close();
	}
	
	// 저장에 실패하였다면?
	if (list == null) {
		helper.printJsonRt("덧글 목록 조회에 실패했습니다.");
		return;
	}
	
	/****** JSON 결과 출력하기 *******/
	// 새롭게 구성할 덧글 목록
	List<JSONObject> json_list = new ArrayList<JSONObject>();
	
	// 조회된 글 수 만큼 반복한다.
	for (int i=0; i<list.size(); i++) {
		// 덧글 내용에서 줄 바꿈 문자를 <br /> 태그로 변경한다.
		BBSComment item = list.get(i);
		String content = item.getContent();
		String content_replace = content.replace("\n", "<br />");

		// 글 하나의 항목을 별도의 JSONObject로 구성한다.
		JSONObject item_json = new JSONObject();
		item_json.put("id", 				item.getId());
		item_json.put("bbs_document_id", 	item.getBbsDocumentId());
		item_json.put("writer_name", 		item.getWriterName());
		item_json.put("writer_pw", 			item.getWriterPw());
		item_json.put("email", 				item.getEmail());
		item_json.put("content", 			content_replace);
		item_json.put("ip_address", 		item.getIpAddress());
		item_json.put("reg_date", 			item.getRegDate());
		item_json.put("edit_date", 			item.getEditDate());
		
		// 덧글 목록을 위한 컬렉션에 데이터 추가
		json_list.add(item_json);	
	}

	// 출력할 JSON 구성하기
	JSONObject json = new JSONObject();
	json.put("rt", "SUCCESS");
	json.put("item", json_list);
	out.print(json.toString());
%>