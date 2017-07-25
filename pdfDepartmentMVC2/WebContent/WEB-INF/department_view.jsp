<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<title>My JSP Page</title>
	<!-- Twitter Bootstrap3 & jQuery -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css" />
	<script src="http://code.jquery.com/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<div class="page-header row">
			<div class='col-md-12'>
				<h1 style="margin-top: 0">학과정보</h1>	
			</div>
		</div>
		<!-- 조회결과 출력 -->
		<ul class="list-group">
			<li class="list-group-item">학과번호: ${department.deptno}</li>
			<li class="list-group-item">학과이름: ${department.dname}</li>
			<li class="list-group-item">위치: ${department.loc}</li>
		</ul>
		<!-- 버튼들 -->
		<p class="text-center">
			<a href="department_list.do" class="btn btn-success">목록</a>
			<a href="department_write.do" class="btn btn-primary">추가</a>
			<a href="department_edit.do?deptno=${department.deptno}"
					class="btn btn-info">수정</a>
			<a href="department_delete.do?deptno=${department.deptno}"
					class="btn btn-danger">삭제</a>
		</p>
	</div>
</body>
</html>