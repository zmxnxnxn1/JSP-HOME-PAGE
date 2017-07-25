<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
				<h1 style="margin-top: 0">학과수정</h1>	
			</div>
		</div>
		
		<form name="myform" method="post" action="department_edit_ok.do" 
			role="form">
			<!-- 학과 번호에 대한 상태유지 -->
			<input type="hidden" name="deptno" value="${department.deptno}" />

			<!-- 수정 내용에 대한 입력 요소 -->
			<fieldset>
			    <div class="form-group">
					<label for="dname">학과이름</label>
					<input type="text" name="dname" id="dname"
						value="${department.dname}" class="form-control" />
			    </div>

			    <div class="form-group">
					<label for="loc">위치</label>
					<input type="text" name="loc" id="loc" 
						value="${department.loc}" class="form-control" />
			    </div>

			    <button type="submit" class="btn btn-primary btn-block">
			    	작성완료</button>
			</fieldset>
	    </form>
	</div>
</body>
</html>