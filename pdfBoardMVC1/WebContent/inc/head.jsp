<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
<%
	// 현재 사이트에 대한 웹 상의 디렉토리 경로를 얻는다.
	// --> http://localhost:8080/15-MySite/index.jsp일 경우
	//     /15-MySite를 리턴한다.
	String rootDir = request.getContextPath();
%>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>My JSP Page</title>
<!-- Twitter Bootstrap3 & jQuery -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css" />
<script src="http://code.jquery.com/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
	
<!-- 공통 CSS -->
<link rel="stylesheet" href="<%=rootDir%>/assets/css/common.css" />
	
<!-- Daum 우편번호 검색 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="<%=rootDir%>/assets/js/daumPostcode.js"></script>

<!-- CKEditor -->
<script src="http://cdn.ckeditor.com/4.4.7/standard/ckeditor.js"></script>

<!-- 게시판 덧글 관리 스크립트 -->
<script type="text/javascript" src="<%=rootDir%>/assets/js/bbs_comment.js"></script>

<!-- 템플릿 플러그인 -->
<script type="text/javascript" src="<%=rootDir%>/assets/plugins/tmpl/jquery.tmpl.min.js"></script>

<!-- Multi-column -->
<script type="text/javascript" src="<%=rootDir%>/assets/plugins/multi-column/ie-row-fix.js"></script>
<link rel="stylesheet" href="<%=rootDir%>/assets/plugins/multi-column/multi-columns-row.css" />