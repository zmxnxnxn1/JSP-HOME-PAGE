<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.PageHelper"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>
<%
	/** WebHelper + Logger */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	Logger logger = LogManager.getLogger(request.getRequestURI());

	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
		.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 갤러리에서 최신 글 5개 가져오기 */
	// 게시물 조회 형식을 갤러리로 설정
	BBSDocument galleryDoc = new BBSDocument();
	galleryDoc.setBbsType("gallery");
		
	// 0번째 부터 상위 5개의 글을 조회하도록 Limit 조건 설정
	galleryDoc.setLimitStart(0);
	galleryDoc.setListCount(5);
		
	// 글 조회하기
	List<BBSDocument> galleryList = null;
		
	try {
		galleryList = sqlSession.selectList(
						"BBSDocumentMapper.getGalleryList", galleryDoc);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 공지사항의 최신 글 5개 가져오기 */
	// 게시물 조회 형식을 공지사항으로 설정
	BBSDocument noticeDoc = new BBSDocument();
	noticeDoc.setBbsType("notice");
		
	// 0번째 부터 상위 5개의 글을 조회하도록 Limit 조건 설정
	noticeDoc.setLimitStart(0);
	noticeDoc.setListCount(5);
		
	// 글 조회하기
	List<BBSDocument> noticeList = null;
		
	try {
		noticeList = sqlSession.selectList(
						"BBSDocumentMapper.getDocumentList", noticeDoc);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 자유게시판의 최신 글 5개 가져오기 */
	// 게시물 조회 형식을 자유게시판으로 설정
	BBSDocument freeDoc = new BBSDocument();
	freeDoc.setBbsType("free");
		
	// 0번째 부터 상위 5개의 글을 조회하도록 Limit 조건 설정
	freeDoc.setLimitStart(0);
	freeDoc.setListCount(5);
		
	// 글 조회하기
	List<BBSDocument> freeList = null;
		
	try {
		freeList = sqlSession.selectList(
						"BBSDocumentMapper.getDocumentList", freeDoc);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 질문/답변 게시판의 최신 글 5개 가져오기 */
	// 게시물 조회 형식을 질문/답변으로 설정
	BBSDocument qnaDoc = new BBSDocument();
	qnaDoc.setBbsType("qna");
		
	// 0번째 부터 상위 5개의 글을 조회하도록 Limit 조건 설정
	qnaDoc.setLimitStart(0);
	qnaDoc.setListCount(5);
		
	// 글 조회하기
	List<BBSDocument> qnaList = null;
		
	try {
		qnaList = sqlSession.selectList(
						"BBSDocumentMapper.getDocumentList", qnaDoc);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}

	/** 데이터베이스 접속 해제 */
	sqlSession.close();
%>
<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp" %>
</head>
<body>
	<%@ include file="/inc/topbar.jsp" %>
	<!-- 캐러셀 갤러리 -->
<%
	// 갤러리 데이터가 존재한다면?
	if (galleryList != null) {
%>
		<!-- 캐러셀 영역 구성 -->
		<div id="carousel-generic" class="carousel slide" data-ride="carousel">
			<!-- 현재 위치 표시 -->
			<ol class="carousel-indicators">
<%
		/** 현재 위치를 표시하기 위한 동그라미 아이콘 출력 처리 */
		String clsName = "";
		for (int i=0; i<galleryList.size(); i++) {
			// 첫 번째 항목에는 "active"클래스를 추가한다.
			if (i == 0) {
				clsName = "active";
			} else {
				clsName = "";
			} // end if
%>
				<li data-target="#carousel-generic" data-slide-to="<%=i%>" 
					class="<%=clsName%>"></li>
<%
		} // end for
%>
			</ol>

			<!-- 내용 영역 -->
			<div class="carousel-inner">
<%
		/** 이미지 출력 처리 */
		for (int i=0; i<galleryList.size(); i++) {
			if (i == 0) {
				clsName = "active";
			} else {
				clsName = "";
			} // end if
			
			BBSDocument item = galleryList.get(i);
%>
				<div class="item <%=clsName%>">
					<!-- 이미지 슬라이더 -->
					<img src="bbs/download.jsp?file=<%=item.getFile()%>">
					<div class="container">
						<div class="carousel-caption">
							<!-- 제목 -->
							<h1><%=item.getSubject()%></h1>
							<!-- 본문 -->
							<p><%=item.getContent()%></p>
							<!-- 읽기로 가기 위한 링크 -->
							<a href="bbs/read.jsp?bbs_type=gallery&document_id=<%=item.getId()%>" class="btn btn-primary">View</a>
						</div>
					</div>
				</div>
<%			
		} // end for
%>
			</div>

			<!-- 이동 버튼 -->
			<a class="left carousel-control" href="#carousel-generic" data-slide="prev"> <span class="icon-prev"></span> </a>
			<a class="right carousel-control" href="#carousel-generic" data-slide="next"> <span class="icon-next"></span> </a>
		</div>
<%
	} // end if
%>	
	<!--// 캐러셀 갤러리 -->
	<div class="container">
		
		<div class="row">
			<!-- 개념정리 -->
			<div class="col-md-4">
				<div class="clearfix" style="margin-bottom: 10px">
					<h3 class="pull-left" style="margin: 0px; padding: 0px">
						개념정리</h3>
					<div class="pull-right">
						<a href="bbs/list.jsp?bbs_type=notice" class="btn btn-xs btn-primary">more</a>
					</div>
				</div>
				<ul class="list-group">
					<!-- 글 목록 -->
<%
	if (noticeList != null) {
		for (int i=0; i<noticeList.size(); i++) {
			BBSDocument notice = noticeList.get(i);
%>
					<li class="list-group-item">
						<a href="bbs/read.jsp?bbs_type=notice&document_id=<%=notice.getId()%>">
							<%=notice.getSubject()%></a>
					</li>
<%			
		}
	}
%>
					<!--// 글 목록 -->
				</ul>
			</div>
			<!--// 개념정리 -->
			
			<!-- 자유게시판 -->
			<div class="col-md-4">
				<div class="clearfix" style="margin-bottom: 10px">
					<h3 class="pull-left" style="margin: 0px; padding: 0px">
						자유게시판</h3>
					<div class="pull-right">
						<a href="bbs/list.jsp?bbs_type=free" class="btn btn-xs btn-success">more</a>
					</div>
				</div>
				<ul class="list-group">
					<!-- 글 목록 -->
<%
	if (freeList != null) {
		for (int i=0; i<freeList.size(); i++) {
			BBSDocument free = freeList.get(i);
%>
					<li class="list-group-item">
						<a href="bbs/read.jsp?bbs_type=free&document_id=<%=free.getId()%>">
							<%=free.getSubject()%></a>
					</li>
<%			
		}
	}
%>
					<!--// 글 목록 -->
				</ul>
			</div>
			<!--// 자유게시판 -->
			
			<!-- 코드파이터 -->
			<div class="col-md-4">
				<div class="clearfix" style="margin-bottom: 10px">
					<h3 class="pull-left" style="margin: 0px; padding: 0px">
						코드파이터</h3>
					<div class="pull-right">
						<a href="bbs/list.jsp?bbs_type=qna" class="btn btn-xs btn-warning">more</a>
					</div>
				</div>
				<ul class="list-group">
					<!-- 글 목록 -->
<%
	if (qnaList != null) {
		for (int i=0; i<qnaList.size(); i++) {
			BBSDocument qna = qnaList.get(i);
%>
					<li class="list-group-item">
						<a href="bbs/read.jsp?bbs_type=qna&document_id=<%=qna.getId()%>">
							<%=qna.getSubject()%></a>
					</li>
<%			
		}
	}
%>
					<!--// 글 목록 -->
				</ul>
			</div>
			<!--// 코드파이터 -->
		</div>
		
	</div>
	
	<%@ include file="/inc/footer.jsp" %>
</body>
</html>