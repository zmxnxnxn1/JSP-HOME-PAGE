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
	<!-- 내용영역 -->
	<div class="container">
		
		<h1 class="page-header">Jelting 소개</h1>
		
		<!-- 그리드 시스템 (데스크탑 가로3칸) -->
		<div class="row">
			<div class="col-md-4 text-center">
				<img src="../assets/img/html5.jpg" class="img-circle" width="240" height="240"/>
				<h2>대화</h2>
				<p>
					Jelting은 자유롭게 채팅을 할 수 있습니다. 이것은 놀랍게도 무료입니다.
					실시간 채팅을 자유롭게 이용할 수 있으며 익명으로 개인정보를 수집하지 않습니다.
				</p>
			</div>
			<div class="hidden-lg hidden-md">
				<br/>
				<br/>
			</div>
			<div class="col-md-4 text-center">
				<img src="../assets/img/css3.jpg" class="img-circle" width="240" height="240"/>
				<h2>채팅방</h2>
				<p>
					채팅방을 개설하여 원하는 상대와 대화를 할 수 있습니다.
					또한 비공개로 설정하여 허용한 인원만 접속할 수 있도록 설정이 가능합니다.
				</p>
			</div>
			<div class="hidden-lg hidden-md">
				<br/>
				<br/>
			</div>
			<div class="col-md-4 text-center">
				<img src="../assets/img/bs3.jpg" class="img-circle" width="240" height="240"/>
				<h2>플러그인</h2>
				<p>
					다른 작업중이더라도 플러그인을 통하여 새로운 채팅이 있음을 알려줍니다.
					이것은 다른곳에 없는 완벽하고도 훌륭한 아이디어 입니다.
				</p>
			</div>
		</div>
		<!--// 그리드 시스템 -->

		<hr class="featurette-divider">

		<div class="row featurette">
			<div class="col-md-7">
				<h2 class="featurette-heading">메인화면입니다. <span class="text-muted">마음에 드실겁니다.</span></h2>
				<p class="lead">
					가장 심플한 것이 가장 화려한 것이라는 말이 있습니다. 실제로 Jelting을 통하여 익명의 대화를 경험해 보신다면, 매력에 반하시게 될 것입니다.
				</p>
			</div>
			<div class="col-md-5">
				<img class="img-thumbnail img-responsive" src="../assets/img/main.png" width="500" height="500" />
			</div>
		</div>

		<hr class="featurette-divider">

		<div class="row featurette">
			<div class="col-md-5">
				<img class="img-thumbnail img-responsive" src="../assets/img/create.png" width="500" height="500" />
			</div>
			<div class="col-md-7">
				<h2 class="featurette-heading">무척 쉽습니다. <span class="text-muted">직접 경험해 보세요.</span></h2>
				<p class="lead">
					Jelting의 모든 기능은 심플하고 직관적입니다. 빠르게 방을 개설하고, 익명의 사용자와 대화가 가능합니다. 이 대화방의 활용도의 가능성은 무한대 입니다.
				</p>
			</div>
		</div>

		<hr class="featurette-divider">

		<div class="row featurette">
			<div class="col-md-7">
				<h2 class="featurette-heading">크롬 플러그인을 사용 해보세요. <span class="text-muted">정말 멋집니다.</span></h2>
				<p class="lead">
					지금 경험하시고 있는 채팅과는 다릅니다. 이것은 매우 어메이징합니다. 일단 설치해보세요. 그리고 알람을 받으세요. <br />
					알람을 받으시려면 <a href="https://chrome.google.com/webstore/detail/jelting-plugin/jdndiilmnjebfhmhlfdibkohmcoffecl?hl=ko" target="_blank">Click</a> 하세요.
				</p>
			</div>
			<div class="col-md-5">
				<img class="img-thumbnail img-responsive" src="../assets/img/alarm.png" width="500" height="500" />
			</div>
		</div>
	</div>
	<!--// 내용영역 -->
	<%@ include file="/inc/footer.jsp" %>
</body>
</html>