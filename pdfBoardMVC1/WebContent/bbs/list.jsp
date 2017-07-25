<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ include file="/inc/init.jsp" %>
<%@ include file="/inc/bbs_config.jsp" %>

<%
	// 목록 스타일에 따라서 서로 다른 리스트 파일을 호출한다.
	if (list_style.equals("gallery")) {
		pageContext.forward("list_gallery.jsp");
	} else {
		pageContext.forward("list_board.jsp");
	}
%>