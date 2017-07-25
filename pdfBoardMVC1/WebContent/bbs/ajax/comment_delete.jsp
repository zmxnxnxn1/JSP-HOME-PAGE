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
    /** 파라미터 받기 + 로그 기록 */
    WebHelper helper = WebHelper.getInstance(request, response, out);
    Logger logger = LogManager.getLogger(request.getRequestURI());
    int comment_id = helper.getInt("comment_id");
    logger.debug("comment_id=" + comment_id);
    
    // 파라미터가 없다면 삭제 대상이 지정되지 않은 상태이므로 실행 취소
    if (comment_id < 1) {
        helper.redirect(null, "덧글 일련번호가 없습니다.");
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
        
        // 덧글 내용을 조회한다.
        SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
                .getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        
        // 덧글 정보 객체
        BBSComment comment = null;

        try {
            comment = sqlSession.selectOne(
                            "BBSCommentMapper.getCommentItem", comment_id);
        } catch (Exception e) {
            logger.error(e.getMessage());
        } finally {
            sqlSession.close();
        }

        // 조회결과가 있다면? 게시물에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
        if (comment != null) {
            if (comment.getMemberId() == my_member_id) {
                my_comment = true;  // --> 내가 작성한 글임
            }
        }
    } // end if
    
%> 
<form class="delete_comment" method="post" action="ajax/delete_comment.jsp">
    <!-- 글 번호 상태 유지 -->
    <input type="hidden" name="comment_id" value='<%=comment_id%>' />
    
    <!-- modal 창 상단 영역 -->
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" 
        aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="comment_delete_title">덧글 삭제 확인</h4>
    </div>
    
    <!-- modal 창 내용 영역 -->
    <div class="modal-body">

<%
    if (my_comment == false) {	// 자신의 글이 아닌 경우는 비밀번호를 입력받는다.
%>
        <p>덧글 작성시 설정한 비밀번호를 입력하세요.</p>  
        <div class="form-group">
            <input type="password" class="form-control" name="pwd">
        </div>
<%
    } else {					// 자신의 글이 맞다면 비밀번호 입력을 생략한다
%>
        <p>정말 덧글을 삭제하시겠습니까?</p>
        <!-- 자신의 덧글임을 알린다. -->
		<input type="hidden" name="is_mine" value="Y" />
<%
    }
%>
    </div>

    <!-- modal 창 하단 영역 -->
    <div class="modal-footer">
        <button type="button" class="btn btn-default" 
        	data-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-danger">삭제</button>
    </div>
</form>