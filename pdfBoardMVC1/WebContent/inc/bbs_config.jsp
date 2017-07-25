<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="study.java.helper.WebHelper"%>
<%
	// 일단 파라미터 값을 받는다. 메뉴를 통해서 전달될 것이다.
	String bbs_type = WebHelper.getInstance(request, response, out).getString("bbs_type");

	if (bbs_type != null) {
		// 파라미터 값이 null이 아니라면?
		// --> 메뉴에서 목록으로 bbs_type이 전달되면 세션에 저장한다.
		session.setAttribute("bbs_type", bbs_type);
	} else {
		// 값이 없다면 세션에 보관되어 있는 값을 꺼낸다.
		bbs_type = (String) session.getAttribute("bbs_type");
	}
	
	if (bbs_type == null) {
		WebHelper.getInstance(request, response, out).redirect(null, "게시판 종류가 지정되지 않았습니다.");
	}
	
	// 게시판 식별자에 따라서 게시판의 이름을 지정한다.
	String bbs_name = null;
	
	if (bbs_type.equals("notice")) {
		bbs_name = "개념정리";
	} else if (bbs_type.equals("free")) {
		bbs_name = "자유게시판";
	} else if (bbs_type.equals("qna")) {
		bbs_name = "질문/답변";
	} else if (bbs_type.equals("gallery")) {
		bbs_name = "포토갤러리";
	}
	
	// 게시판 식별자에 따라서 게시판의 형식을 지정한다.
	String list_style = "board";
	if (bbs_type.equals("gallery")) {
		list_style = "gallery";
	}
%>