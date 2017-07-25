<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="java.util.List"%>
<%@ page import="study.jsp.mysite.model.BBSFile"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp"%>
<%@ include file="/inc/bbs_config.jsp"%>

<%
	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	int document_id = helper.getInt("document_id");
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("document_id=" + document_id);
	
	/** 파라미터가 없다면 읽을 대상이 지정되지 않은 상태이므로 실행 취소 */
	if (document_id < 1) {
		helper.redirect(null, "게시물 일련번호가 없습니다.");
		return;
	}
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 게시물 데이터 조회 */
	BBSDocument document = null;
	
	try {
		// 특정 게시물 정보 조회하기
		document = sqlSession.selectOne(
						"BBSDocumentMapper.getDocumentItem", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	// 조회결과가 없다면?
	if (document == null) {
		sqlSession.close();
		helper.redirect(null, "조회된 게시물이 없습니다.");
		return;
	}
	
	/** 첨부파일 데이터 조회 */
	List<BBSFile> fileList = null;
	
	try {
		// 특정 게시물에 속한 파일정보 조회하기
		fileList = sqlSession.selectList(
						"BBSFileMapper.getFileList", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	/** 세션정보를 조회해서 현재 접속자의 회원 번호와 DB에 저장된 회원번호를 비교한다. */
	// 내 글인지 판단하기 위한 변수
	boolean my_article = false;
	// 세션정보 얻기
	Member myinfo = (Member) session.getAttribute("member");
	
	// 로그인 한 회원정보가 존재한다면?
	if (myinfo != null) {
		// 현재 접속자의 회원 일련번호
		int my_member_id = myinfo.getId();

		// 게시물에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
		if (document.getMemberId() == my_member_id) {
			my_article = true;	// --> 내가 작성한 글임
		}
	} // end if
%>
<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp"%>
	<script>
		function submitEdit() {
			if (!confirm("저장하시겠습니까?")) return;
			$("form[name=editForm]").submit();
		}
	</script>
</head>
<body>
	<%@ include file="/inc/topbar.jsp"%>
	<div class="container">

		<h1 class="page-header">
			<%=bbs_name%> <small>- 글 수정하기</small>
		</h1>

		<form name="editForm" class="form-horizontal" role="form" method="post" action="edit_ok.jsp" enctype="multipart/form-data">

			<!-- 게시물 일련번호의 상태유지 -->
			<input type="hidden" name="document_id" value="<%=document_id %>" />

<%
	if (my_article == true) {
%>
			<!-- 자신의 글을 수정함을 알림 -->
		    <input type='hidden' name='is_mine' value='Y' />
<%		
	} else {
		// 자신의 글이 아닌 경우는 이름,비밀번호,이메일을 입력받는다.
%>	
			<!-- 작성자 -->
			<div class="form-group">
				<label for="writer_name" class="col-sm-2 control-label">
					작성자</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="writer_name" name="writer_name" value="<%=document.getWriterName()%>" />
				</div>
			</div>

			<!-- 비밀번호 -->
			<div class="form-group">
				<label for="writer_pw" class="col-sm-2 control-label">
					비밀번호</label>
				<div class="col-sm-10">
					<input type="password" class="form-control" 
						id="writer_pw" name="writer_pw">
					<p class="help-block text-danger">
						글 작성시 설정하신 비밀번호를 입력하세요.
					</p>
				</div>
			</div>

			<!-- 이메일 -->
			<div class="form-group">
				<label for="email" class="col-sm-2 control-label">
					이메일</label>
				<div class="col-sm-10">
					<input type="email" class="form-control" id="email" 
						name="email" value="<%=document.getEmail()%>" />
				</div>
			</div>
<%
	} // end if
%>
			<!-- 제목 -->
			<div class="form-group">
				<label for="subject" class="col-sm-2 control-label">
					제목</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="subject" 
						name="subject" value="<%=document.getSubject()%>" />
				</div>
			</div>
			
			<!-- 내용 -->
			<div class="form-group">
				<label for="content" class="col-sm-2 control-label">
					내용</label>
				<div class="col-sm-10">
					<textarea id="content" name="content" 
						class="ckeditor"><%=document.getContent()%></textarea>
				</div>
			</div>
			
			<!-- 파일업로드 -->
			<div class="form-group">
				<label for="file" class="col-sm-2 control-label">
					파일첨부</label>
				<div class="col-sm-10">
					<input type="file" class="form-control" id="file" name="file" multiple>
				</div>
			</div>
			
			
			<!-- 파일삭제 -->
			<div class="form-group">
				<label class="col-sm-2 control-label">
					파일삭제</label>
				<div class="col-sm-10">
					<div class="form-control" style="height: auto; padding-top: 0px">
						<%
							// 조회한 파일 목록의 수 만큼 반복처리
							for (int i=0; i<fileList.size(); i++) {
								// 파일의 원본 이름과 일련번호 추출
								BBSFile item = fileList.get(i);
								int file_id = item.getId();
								String orgin_name = item.getOrginName();
								
								// 업로드 되어 있는 파일의 목록을 제시하고,
								// 삭제할 파일을 선택하도록 체크박스를 추가한다.
						%>
						<div class="checkbox">
							<label>
								<input type="checkbox" name="file_delete" value="<%=file_id%>" />
								<%=orgin_name %> 삭제하기
							</label>
						</div>
						<% } %>	
					</div>
				</div>
			</div>
			
			<!-- 버튼들 -->
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="button" class="btn btn-primary" onclick="javascript:submitEdit();">
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