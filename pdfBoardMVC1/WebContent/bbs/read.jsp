<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="java.net.URLEncoder"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="java.util.List"%>
<%@ page import="study.jsp.mysite.model.BBSFile"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>
<%@ include file="/inc/bbs_config.jsp" %>

<%
	// 로그인 검사를 위해서 세션 정보 가져오기
	Member myinfo = (Member) session.getAttribute("member");

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
	
	/** 조회수 갱신 */
	// 게시물 일련번호를 사용해서 쿠키의 이름을 만든다. --> 게시물마다 이름이 달라진다.
	String cookieName = "bbs_document_" + document_id;
	
	// 게시물 일련번호가 적용된 이름의 쿠키가 존재하지 않는다면 조회수를 갱신한다.
	// 하루 이내에 같은 게시물을 여러번 보더라도 한 번만 조회수를 갱신하게 된다.
	if (helper.getCookie(cookieName) == null) {
		try {
			sqlSession.update("BBSDocumentMapper.doUpdateHit", document_id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			// 변경사항 저장 -> 조회할 데이터가 남아 있으므로 접속은 유지한다.
			sqlSession.commit();
		}

		// 게시물 일련번호를 활용하여 쿠키를 24시간 동안 저장하기
		helper.setCookie(cookieName, "Y", 60 * 60 * 24);
	}
	
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
	
	/** 이전 글 데이터 조회 */
	BBSDocument prevDocument = null;

	try {
		prevDocument = sqlSession.selectOne(
							"BBSDocumentMapper.getPrevItem", document);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 다음 글 데이터 조회 */
	BBSDocument nextDocument = null;

	try {
		nextDocument = sqlSession.selectOne(
							"BBSDocumentMapper.getNextItem", document);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 데이터베이스 접속해제 */
	sqlSession.close();
%>

<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp" %>
</head>
<body>
	<%@ include file="/inc/topbar.jsp" %>
	<div class="container">
		<h1 class="page-header">
			<%=bbs_name%><small>- 글 읽기</small>
		</h1>
		
		<!-- 제목, 작성자, 작성일시, 조회수 -->
		<div class="alert alert-info" role="alert">
		    <h3 style='margin: 0'>
		    	<%=document.getSubject()%>
		        <br/>
		        <small>
		            <%=document.getWriterName()%>
		            <a href='mailto:<%=document.getEmail()%>'>
		                <i class='glyphicon glyphicon-envelope'></i></a> 
		            / 조회수 : <%=document.getHit()%>
		            / 작성일시 : <%=document.getRegDate()%>
		        </small>
		    </h3>
		</div>
<%
	if (fileList != null) {
		if (fileList.size() > 0) {
			
			/** 갤러리인 경우 업로드 된 사진을 출력한다. */
			if (list_style.equals("gallery")) {
				// 조회된 파일의 수 만큼 반복
            	for (int i=0; i<fileList.size(); i++) {
            		// 파일 정보 하나를 추출한다.
            		BBSFile fileItem = fileList.get(i);
            		
            		// 파일이 저장된 경로 (폴더경로 + "/" + 파일명)
            		String file_path = fileItem.getFileDir() + '/' + fileItem.getFileName();

            		// 파일의 원본 이름
            		String orgin_name = fileItem.getOrginName();
            		
            		// GET 파라미터 전달을 위해서 URLEncoding 처리
            		String enc_file_path = URLEncoder.encode(file_path, "UTF-8");
            		String enc_orgin_name = URLEncoder.encode(orgin_name, "UTF-8");
%>
					<p class="text-center">
						<img src="download.jsp?file=<%=enc_file_path%>&orgin_name=<%=enc_orgin_name%>" class="img-responsive" />
					</p>	
<%	
            	}
			} else {
%>
		<!-- 첨부파일 목록 -->
		<table class='table table-bordered'>
		    <tbody>
		        <tr>
		            <th class='warning' style='width: 100px'>첨부파일</th>
		            <td>
		            <%
		            	// 조회된 파일의 수 만큼 반복
		            	for (int i=0; i<fileList.size(); i++) {
		            		// 파일 정보 하나를 추출한다.
		            		BBSFile fileItem = fileList.get(i);
		            		
		            		// 파일이 저장된 경로 (폴더경로 + "/" + 파일명)
		            		String file_path = fileItem.getFileDir() + '/' + fileItem.getFileName();

		            		// 파일의 원본 이름
		            		String orgin_name = fileItem.getOrginName();
		            		
		            		// GET 파라미터 전달을 위해서 URLEncoding 처리
		            		String enc_file_path = URLEncoder.encode(file_path, "UTF-8");
		            		String enc_orgin_name = URLEncoder.encode(orgin_name, "UTF-8");
		            %>
		            	<a href="download.jsp?file=<%=enc_file_path%>&orgin_name=<%=enc_orgin_name%>"
		            		class='btn btn-link btn-xs'><%=orgin_name%></a>
		            <%
		            	}
		            %>
		            </td>
		        </tr>
		    </tbody>
		</table>
<%
			}
		}
	}
%>		
		<!-- 내용 -->
		<section style='padding: 0 10px 20px 10px'>
		    <%=document.getContent()%>
		</section>
		
		<!-- 다음글/이전글 -->
		<table class='table table-bordered'>
		    <tbody>
		        <tr>
		            <th class='success' style='width: 100px'>다음글</th>
		            <td>
<%
	/** 다음글의 출력 */
	if (nextDocument == null) {
		out.print("다음글이 없습니다.");
	} else {
		// read.jsp로 다음글의 일련번호를 전달하는 링크를 구성한다.
		String link_format = "<a href='read.jsp?document_id=%d'>%s</a>";
		String link = String.format(link_format, 
						nextDocument.getId(), nextDocument.getSubject());
		out.print(link);
	}
%>
		            </td>
		        </tr>
		        <tr>
		            <th class='success' style='width: 100px'>이전글</th>
		            <td>
<%
	/** 이전글의 출력 */
	if (prevDocument == null) {
		out.print("이전글이 없습니다.");
	} else {
		String link_format = "<a href='read.jsp?document_id=%d'>%s</a>";
		String link = String.format(link_format, 
							prevDocument.getId(), prevDocument.getSubject());
		out.print(link);
	}
%>
		            </td>
		        </tr>
		    </tbody>
		</table>
		
		<!-- 버튼들 -->
		<div class='clearfix'>
		    <div class='pull-right'>
		        <a href='list.jsp' class='btn btn-info'>목록보기</a>
		        <a href='write.jsp' class='btn btn-primary'>글쓰기</a>

		        <!-- 수정 대상을 지정하기 위하여 게시물 일련번호를 전달한다. -->
		        <a href='edit.jsp?document_id=<%=document_id%>' 
		        	class='btn btn-warning'>수정하기</a>
		        
		        <!-- 삭제 대상을 지정하기 위하여 게시물 일련번호를 전달한다. -->
		        <a href='delete.jsp?document_id=<%=document_id%>' 
		        		class='btn btn-danger'>삭제하기</a>
		    </div>
		</div>
		
		<!-- 덧글 작성 폼 -->
		<hr />
		<form id="comment_form" role="form" method="post" action="ajax/add_comment.jsp">
		    <!-- 글 번호 상태 유지 -->
		    <input type='hidden' name='document_id' value='<%=document_id%>' />
		    <fieldset>
		        <div class='form-group form-inline'>
		        <% if (myinfo == null) { %>
					<!-- 이름, 비밀번호, 이메일 -->
		            <div class="form-group">
		                <input type="text" name="writer_name" 
		                	class="form-control" placeholder='작성자'/>
		            </div>
		            <div class="form-group">
		                <input type="password" name="writer_pw" 
		                	class="form-control" placeholder='비밀번호'/>
		            </div>
		            <div class="form-group">
		                <input type="email" name="email" 
		                	class="form-control" placeholder='이메일'/>
		            </div>
		        <% } %>
		        </div>
		        <div class='form-group'>
		        	<!-- 내용입력, 저장버튼 -->
			        <div class="input-group">
					    <textarea class="form-control custom-control" name='content' 
					    	style="resize:none; height: 80px"></textarea>     
					    <span class="input-group-btn">
					    	<button type="submit" class="btn btn-success" 
					    		style="height: 80px">저장</button>
					    </span>
					</div>
		        </div>
		    </fieldset>
		</form>
		
		<!-- 덧글 리스트 -->
		<ul class="media-list" id="comment_list" 
				data-list="ajax/get_comment_list.jsp?document_id=<%=document_id%>">
		</ul>
		
	</div>
	<%@ include file="/inc/footer.jsp" %>
	
    <%@ include file="/bbs/template/comment_item.jsp" %>

</body>
</html>