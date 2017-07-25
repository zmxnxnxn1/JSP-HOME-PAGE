<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="study.jsp.mysite.model.Member"%>
<%@ page import="study.jsp.mysite.model.BBSComment"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>

<%
	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	int comment_id = helper.getInt("comment_id");
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("comment_id=" + comment_id);
	
	/** 파라미터가 없다면 수정 대상이 지정되지 않은 상태이므로 실행 취소 */
	if (comment_id < 1) {
		helper.redirect(null, "덧글 일련번호가 없습니다.");
		return;
	}
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 덧글 데이터 조회 */
	BBSComment comment = null;
	
	try {
		// 특정 덧글 정보 조회하기
		comment = sqlSession.selectOne(
						"BBSCommentMapper.getCommentItem", comment_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	// 조회결과가 없다면?
	if (comment == null) {
		sqlSession.close();
		helper.redirect(null, "조회된 덧글이 없습니다.");
		return;
	}
	
	/** 세션정보를 조회해서 현재 접속자의 회원 번호와 DB에 저장된 회원번호를 비교한다. */
	// 내 글인지 판단하기 위한 변수
	boolean my_comment = false;
	// 세션정보 얻기
	Member myinfo = (Member) session.getAttribute("member");
	
	// 로그인 한 회원정보가 존재한다면?
	if (myinfo != null) {
		// 현재 접속자의 회원 일련번호
		int my_member_id = myinfo.getId();
	
		// 덧글에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
		if (comment.getMemberId() == my_member_id) {
			my_comment = true;	// --> 내가 작성한 글임
		}
	} // end if
    
%> 
<form class="edit_comment form-horizontal" method="post" action="ajax/edit_comment.jsp">
    <!-- 글 번호 상태 유지 -->
    <input type="hidden" name="comment_id" value='<%=comment_id%>' />
    
    <!-- modal 창 상단 영역 -->
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        	<span aria-hidden="true">&times;</span></button>
        <h4 class="comment_delete_title">덧글 수정하기</h4>
    </div>
    
    <!-- modal 창 내용 영역 -->
    <div class="modal-body">

<%
    if (my_comment == false) {	// 자신의 글이 아닌 경우는 비밀번호를 입력받는다.
%>
		<div class="form-group">
			<label for="writer_name" class="col-sm-2 control-label">작성자</label>
			<div class="col-sm-10">
				<input type="text" name="writer_name" id="writer_name" class="form-control" placeholder='작성자' value="<%=comment.getWriterName()%>"/>
			</div>
		</div>
		<div class="form-group">
			<label for="writer_pw" class="col-sm-2 control-label">비밀번호</label>
			<div class="col-sm-10">
				<input type="password" name="writer_pw" id="writer_pw" class="form-control" placeholder='비밀번호'/>
			</div>
		</div>
		<div class="form-group">
			<label for="email" class="col-sm-2 control-label">이메일</label>
			<div class="col-sm-10">
				<input type="email" name="email" id="email" class="form-control" placeholder='이메일' value="<%=comment.getEmail()%>"/>
			</div>
		</div>
<%
    } else {					// 자신의 글이 맞다면 비밀번호 입력을 생략한다
%>
        <!-- 자신의 덧글임을 알린다. -->
		<input type="hidden" name="is_mine" value="Y" />
<%
    }
%>
		<!-- 덧글 내용 -->
		<div class="form-group">
			<label for="content" class="col-sm-2 control-label">덧글 내용</label>
			<div class="col-sm-10">
				<textarea class="form-control" name='content' id="content" style="resize:none; height: 80px"><%=comment.getContent()%></textarea>
			</div> 
		</div>
    </div>

    <!-- modal 창 하단 영역 -->
    <div class="modal-footer">
        <button type="button" class="btn btn-default" 
        	data-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-info">수정</button>
    </div>
</form>