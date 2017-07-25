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
	<div class='container'>
		<div class='page-header'>
			<h1>회원가입</h1>
		</div>

		<!-- 가입폼 시작 -->
		<form name="myform" method="post" action="join_ok.jsp" role="form">
			<fieldset>
				<div class="form-group">
					<label for='user_id'>아이디</label>
					<input type="text" name="user_id"
						id="user_id" class="form-control" />
				</div>
				<div class="form-group">
					<label for='user_pw'>비밀번호</label>
					<input type="password" name="user_pw" id="user_pw" 
						class="form-control" />
				</div>
				<div class="form-group">
					<label for='user_pw_re'>비밀번호 확인</label>
					<input type="password" name="user_pw_re" 
						id="user_pw_re" class="form-control" />
				</div>
				<div class="form-group">
					<label for='user_name'>이름</label>
					<input type="text" name="user_name" id="user_name" 
						class="form-control" />
				</div>
				<div class="form-group">
					<label for='email'>이메일</label>
					<input type="email" name="email" id="email" 
						class="form-control" />
				</div>
				<div class="form-group">
					<label for='tel'>연락처</label> 
					<input type="tel" name="tel" id="tel" class="form-control" />
				</div>
				<div class="form-group">
					<label for='post1'>우편번호</label>
					<div class="input-group" style="width: 250px">
						<input type="text" name='postcode' id='postcode' class="form-control" readonly>
						<span class="input-group-btn">
							<button class="btn btn-default" type="button" onclick="execDaumPostcode('postcode', 'addr1', 'addr2')">우편번호 찾기</button>
						</span>
					</div>
				</div>
				<div class="form-group">
					<label for='addr1'>주소</label>
					<input type="text" name="addr1" id="addr1" class="form-control" />
				</div>
				<div class="form-group">
					<label for='addr2'>상세주소</label>
					<input type="text" name="addr2" id="addr2" class="form-control" />
				</div>
				<div class="form-group text-center">
					<button type="submit" class="btn btn-primary">가입하기</button>
					<button type="reset" class="btn btn-danger">다시작성</button>
				</div>
			</fieldset>
		</form>
		<!-- 가입폼 끝 -->

	</div>
	<%@ include file="/inc/footer.jsp" %>
</body>
</html>