<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ include file="/inc/init.jsp" %>

<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp" %>
</head>
<body>
	<%@ include file="/inc/topbar.jsp" %>
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<h1 class="page-header">비밀번호 재설정</h1>
				<p>가입시 입력한 이메일 주소를 입력하세요. 임시 비밀번호를 이메일로 보내드립니다.</p>
				
				<form name="myform" method="post" action="find_pw_ok.jsp" role="form">
					<fieldset>
						<div class="form-group">
							<input type="text" name="email" id="email" class="form-control" />
						</div>
						<div class="form-group">
							<button type="submit" class="btn btn-primary btn-block">
								비밀번호 재설정 하기</button>
						</div>
					</fieldset>
				</form>
				
			</div>
		</div>
	</div>
	<%@ include file="/inc/footer.jsp" %>
</body>
</html>