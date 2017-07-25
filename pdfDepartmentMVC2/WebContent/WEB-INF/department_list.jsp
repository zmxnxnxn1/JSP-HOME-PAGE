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
		<!-- 페이지 제목 + 검색폼 -->
		<div class="page-header row">
			<div class='col-md-6'>
				<h1 style="margin-top: 0"><a href="department_list.do">학과등록</a></h1>	
			</div>
			<div class='col-md-6 text-right'>
				<form method='get' action='department_list.do' class="form-inline">
					<div class="input-group">
						<input type="text" name='keyword' class="form-control" 
							placeholder="학과명 검색" value="${keyword}" />
						<span class="input-group-btn">
							<button class="btn btn-success" type="submit">
								<i class='glyphicon glyphicon-search'></i>
							</button>
							<a href="department_write.do" class="btn btn-primary">
								학과추가</a>
						</span>
					</div>
				</form>
			</div>
		</div>
		
		<!-- 학과 목록 테이블 구성하기 -->
		<table class='table table-striped'>
			<thead>
				<tr>
					<th class='text-center'>학과번호</th>
					<th class='text-center'>학과이름</th>
					<th class='text-center'>학과위치</th>
					<th class='text-center'>수정/삭제</th>
				</tr>
			</thead>
			<tbody>
				<!-- dept_list로 넘어온 컬렉션에 대한 반복 처리 -->
				<c:forEach var="item" items="${dept_list}" varStatus="status">
					
					<!-- 읽기 페이지로 이동하기 위한 URL 추가 -->
					<c:url value="department_view.do" var="view_url">
						<c:param name="deptno" value="${item.deptno}"></c:param>
					</c:url>
					
					<tr>
						<td class='text-center'>${item.deptno}</td>
						<td class='text-center'>
							<a href="${view_url}">${item.dname}</a>
						</td>
						<td class='text-center'>${item.loc}</td>
						<td class='text-center'>
							<a href='department_edit.do?deptno=${item.deptno}' class='btn btn-xs btn-warning'>수정</a>
							<a href='department_delete.do?deptno=${item.deptno}' class='btn btn-xs btn-danger'>삭제</a>
						</td>
					</tr>
				</c:forEach>
				<!--// 반복처리 끝 -->
			</tbody>
		</table>
		
		<!-- 페이지 번호 -->
		<nav class='text-center'>
    		<ul class="pagination">
        		<!-- 이전 그룹 -->
        		<c:choose>
					<c:when test="${page_helper.prevPage > 0}">
        				<!-- 이전 그룹에 대한 페이지 번호가 존재한다면? -->
						<!-- 이전 그룹으로 이동하기 위한 URL을 생성해서 "prev_url"에 저장 -->
						<c:url value="department_list.do" var="prev_url">
							<c:param name="keyword" value="${keyword}"></c:param>
							<c:param name="page" value="${page_helper.prevPage}"></c:param>
						</c:url>

						<li>
							<a href="${prev_url}"><span aria-hidden="true">&laquo;</span></a>
						</li>
					</c:when>

					<c:otherwise>
						<!-- 이전 그룹에 대한 페이지 번호가 존재하지 않는다면? -->
						<li class='disabled'>
		        			<a href="#"><span aria-hidden="true">&laquo;</span></a>
		        		</li>	
					</c:otherwise>
				</c:choose>
		        		
				<!-- 페이지 번호 -->
				<!-- 현재 그룹의 시작페이지~끝페이지 사이를 1씩 증가하면서 반복 -->
				<c:forEach var="i" begin="${page_helper.startPage}" 
					end="${page_helper.endPage}" step="1">
					
					<!-- 각 페이지 번호로 이동할 수 있는 URL을 생성하여 page_url에 저장 -->
					<c:url value="department_list.do" var="page_url">
						<c:param name="keyword" value="${keyword}"></c:param>
						<c:param name="page" value="${i}"></c:param>
					</c:url>
					
					<!-- 반복중의 페이지 번호와 현재 위치한 페이지 번호가 같은 경우에 대한 분기 -->
					<c:choose>
						<c:when test="${now_page == i}">
							<li class='active'><a href="#">${i}</a></li>
						</c:when>
						<c:otherwise>
							<li><a href="${page_url}">${i}</a></li>	
						</c:otherwise>
					</c:choose>
				</c:forEach>

        		<!-- 다음 그룹 -->
				<c:choose>
					<c:when test="${page_helper.nextPage > 0}">
        				<!-- 다음 그룹에 대한 페이지 번호가 존재한다면? -->
						<!-- 다음 그룹으로 이동하기 위한 URL을 생성해서 "next_url"에 저장 -->
						<c:url value="department_list.do" var="next_url">
							<c:param name="keyword" value="${keyword}"></c:param>
							<c:param name="page" 
								value="${page_helper.nextPage}"></c:param>
						</c:url>

						<li>
							<a href="${next_url}"><span aria-hidden="true">&raquo;</span></a>
						</li>
					</c:when>

					<c:otherwise>
						<!-- 다음 그룹에 대한 페이지 번호가 존재하지 않는다면? -->
						<li class='disabled'>
		        			<a href="#"><span aria-hidden="true">&raquo;</span></a>
		        		</li>	
					</c:otherwise>
				</c:choose>
			</ul>
		</nav>
	</div>
</body>
</html>
