<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ include file="/inc/init.jsp"%>
<%@ include file="/inc/bbs_config.jsp"%>

<%
	/** 회원정보를 획득하기 위해서 세션데이터 추출하기 */
	Member loginInfo = (Member) session.getAttribute("member");
%>
<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp"%>
	<script>
		function submitWrite() {
			if (!confirm("저장하시겠습니까?")) return;
			$("form[name=writeForm]").submit();
		}
	</script>
</head>
<body>
	<%@ include file="/inc/topbar.jsp"%>
	<div class="container">

		<h1 class="page-header">
			<%=bbs_name%> <small>- 새 글 쓰기</small>
		</h1>

		<form class="form-horizontal" name="writeForm" role="form" method="post" action="write_ok.jsp" enctype="multipart/form-data">
<%
	// 로그인 한 경우 이름, 비밀번호, 이메일은 입력 생략하기
	if (loginInfo == null) {
%>
			<!-- 작성자 -->
			<div class="form-group">
				<label for="writer_name" class="col-sm-2 control-label">
					작성자</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" 
						id="writer_name" name="writer_name">
				</div>
			</div>
			<!-- 비밀번호 -->
			<div class="form-group">
				<label for="writer_pw" class="col-sm-2 control-label">
					비밀번호</label>
				<div class="col-sm-10">
					<input type="password" class="form-control" 
						id="writer_pw" name="writer_pw">
				</div>
			</div>
			<!-- 이메일 -->
			<div class="form-group">
				<label for="email" class="col-sm-2 control-label">
					이메일</label>
				<div class="col-sm-10">
					<input type="email" class="form-control" 
						id="email" name="email">
				</div>
			</div>
<%
	} // 로그인한 경우의 if문 끝
%>
			<!-- 제목 -->
			<div class="form-group">
				<label for="subject" class="col-sm-2 control-label">
					제목</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="subject" name="subject">
				</div>
			</div>
			<!-- 내용 -->
			<div class="form-group">
				<label for="content" class="col-sm-2 control-label">
					내용</label>
				<div class="col-sm-10">
					<textarea id="content" name="content" 
						class="ckeditor"></textarea>
				</div>
			</div>
			<!-- 파일업로드 -->
			<div class="form-group">
				<label for="file" class="col-sm-2 control-label">
					파일첨부</label>
				<div class="col-sm-10">
					<input type="file" class="form-control" id="file" 
						name="file" multiple>
				</div>
			</div>
			<!-- 버튼들 -->
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="button" class="btn btn-primary" onclick="javascript:submitWrite();">
						저장하기</button>
					<button type="button" class="btn btn-danger" 
						onclick="history.back();">작성취소</button>
				</div>
			</div>
		</form>

	</div>
	<%@ include file="/inc/footer.jsp"%>
</body>
</html>