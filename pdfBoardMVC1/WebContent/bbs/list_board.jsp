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
<%@ include file="/inc/bbs_config.jsp" %>

<%
	WebHelper helper = WebHelper.getInstance(request, response, out);
	Logger logger = LogManager.getLogger(request.getRequestURI());
	
	/** 검색어 파라미터 받기 */
	String keyword = helper.getString("keyword");
	logger.debug("keyword=" + keyword);
	
	// 검색어를 Beans에 포함시킨다.
	BBSDocument document = new BBSDocument();
	document.setKeyword(keyword);
	document.setBbsType(bbs_type);

	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 페이지 번호 파라미터 받기 > 기본값은 1로 설정한다 */
	int now_page = helper.getInt("page", 1);

	/** 게시물 수 조회하기 */
	int total_count = 0;
	try {
		// 데이터 조회 결과 호출
		total_count = sqlSession.selectOne("BBSDocumentMapper.getCount", document);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	/** 페이지 구현에 필요한 변수값들을 계산한다. */
	PageHelper pageHelper = PageHelper.getInstance(now_page, total_count, 10, 5);
	logger.debug(pageHelper.toString());
	
	// 페이지 구현 헬퍼에서 계산된 값 중에서 Limit 관련 값을 Beans에 설정한다.
	document.setLimitStart(pageHelper.getLimitStart());
	document.setListCount(pageHelper.getListCount());
	
	/** 게시물 데이터 조회 */
	List<BBSDocument> documentList = null;
	
	try {
		// 특정 게시물 정보 조회하기
		documentList = sqlSession.selectList(
							"BBSDocumentMapper.getDocumentList", document);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		sqlSession.close();
	}
	
	if (documentList == null) {
		helper.redirect(null, "게시물 데이터 조회에 실패했습니다.");
	}
%>
<!doctype html>
<html>
<head>
	<%@ include file="/inc/head.jsp" %>
</head>
<body>
	<%@ include file="/inc/topbar.jsp" %>
	<div class="container">
		<h1 class="page-header"><%=bbs_name%></h1>
		
		<!-- 글 목록 시작 -->
		<div class="table-responsive">
			<table class='table table-hover'>
			    <thead>
			        <tr>
			            <th class='text-center' style='width: 100px'>번호</th>
			            <th class='text-center'>제목</th>
			            <th class='text-center' style='width: 120px'>작성자</th>
			            <th class='text-center' style='width: 100px'>조회수</th>
			            <th class='text-center' style='width: 120px'>작성일</th>
			        </tr>
			    </thead>
			    <tbody>
<%
	// 게시물의 수가 있다면?
    if (documentList.size() > 0) {
    	
    	// 시스템의 1일 전 날짜를 timestamp로 얻기
    	Calendar cal = Calendar.getInstance();
    	cal.add(Calendar.DAY_OF_MONTH, -1);
    	long stamp = cal.getTimeInMillis();
    	
    	String k = cal.get(Calendar.YEAR) + "/" + cal.get(Calendar.MONTH) + "/" + cal.get(Calendar.DAY_OF_MONTH) + "/" + cal.get(Calendar.HOUR) + "/" + cal.get(Calendar.MINUTE);
    	
        for (int i=0; i<documentList.size(); i++) {
        	BBSDocument item = documentList.get(i);
        	
        	// 신규 글인지 판별하기 위한 변수
        	boolean is_new = false;
        	
        	// 게시물의 작성일시를 년/월/일/시/분/초 로 파싱처리 후 -
        	// Calendar 클래스를 사용해서 timestamp로 변환한다.
        	try {
	        	String date = item.getRegDate();
	        	int yy = Integer.parseInt(date.substring(0, 4));
	        	int mm = Integer.parseInt(date.substring(5, 7));
	        	int dd = Integer.parseInt(date.substring(8, 10));
	        	int hh = Integer.parseInt(date.substring(11, 13));
	        	int mi = Integer.parseInt(date.substring(14, 16));
	        	int ss = Integer.parseInt(date.substring(17, 19));
	        	
	        	Calendar itemDate = Calendar.getInstance();
	        	
	        	// Java의 월은 0부터 시작되므로, 설정할 때 -1 처리한다.
	        	itemDate.set(yy, mm-1, dd, hh, mi, ss);
	        	long itemStamp = itemDate.getTimeInMillis();
	        	
	        	// 하루전의 시간보다 게시물 작성일시가 더 이후라면 신규글로 인식함
	        	if (stamp < itemStamp) {
	        		is_new = true;
	        	}
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
%>
	        <tr>
	            <td class='text-center'><%=item.getId()%></td>
	            <td>
	            	<a href='read.jsp?document_id=<%=item.getId()%>'>
	            		<%=item.getSubject()%> </a>
	            	<%
	            		// 신규 일 때, 라벨출력
	            		if (is_new == true) {
	            			out.print("&nbsp;<span class='label label-success'>new</span>");
	            		}
	            	%>
	            </td>
	            <td class='text-center'><%=item.getWriterName()%></td>
	            <td class='text-center'><%=item.getHit()%></td>
	            <td class='text-center'><%=item.getRegDate().substring(0,10)%></td>
	        </tr>
<%
        } // end for
    } else {
%>
	        <tr>
	            <td colspan='5' class='text-center' style='line-height: 100px;'>
	                조회된 글이 없습니다.</td>
	        </tr>
<%
    } // end if
%>
			    </tbody>
			</table>
		</div>
		<!--// 글 목록 끝 -->


		<!-- 검색폼 + 글 쓰기 버튼 -->
		<div class='clearfix'>
		    <div class='pull-left'>
		        <form method='get' action='list.jsp' style='width: 200px'>
		            <div class="input-group">
		            <%
		            	// 검색어가 없는 경우 keyword 변수에는 null이 저장된다.
		            	// 이 값을 value 속성에 출력하면 검색어가 없는 경우
		            	// "null"이라고 표시되므로 공백으로 변경한다.
		            	if (keyword == null) {
		            		keyword = "";
		            	}
		            %>
		                <input type="text" name='keyword' class="form-control" 
		                		placeholder="제목,내용 검색" value="<%=keyword%>" />
		                <span class="input-group-btn">
		                    <button class="btn btn-success" type="submit">
		                        <i class='glyphicon glyphicon-search'></i>
		                    </button>
		                </span>
		            </div>
		        </form>
		    </div>
		    <div class='pull-right'>
		        <a href="write.jsp" class="btn btn-primary">
					<i class="glyphicon glyphicon-pencil"></i>
					글쓰기
				</a>
		    </div>
		</div>
		
		<!-- 페이지 번호 -->
		<%
			// 검색결과가 2페이지 이상 존재한다면, 페이지 번호를 클릭했을 때
			// 검색어에 대한 상태유지가 GET방식으로 처리되어야 한다.
			// 검색어가 한글일 경우 GET파라미터에 포함시키기 위해서는 URLEncoding 처리가 필요하다.
			keyword = URLEncoder.encode(keyword, "utf-8");
		%>
		<nav class='text-center'>
    		<ul class="pagination">
        		<!-- 이전 그룹 -->
				<% if (pageHelper.getPrevPage() > 0) { %>
        		<li>
        			<a href="list.jsp?page=<%=pageHelper.getPrevPage()%>&keyword=<%=keyword%>"><span aria-hidden="true">&laquo;</span></a>
        		</li>
				<% } else { %>
        		<li class='disabled'>
        			<a href="#"><span aria-hidden="true">&laquo;</span></a>
        		</li>
				<% } %>

				<!-- 페이지 번호 -->
				<%
				    for (int i=pageHelper.getStartPage(); i<=pageHelper.getEndPage(); i++) {
				        if (i == now_page) {
				%>
				<li class='active'><a href="#"><%=i%></a></li>
				<%
				        } else {
				%>
				<li><a href="list.jsp?page=<%=i%>&keyword=<%=keyword%>"><%=i%></a></li>
				<%
				        }
				    }
				%>

        		<!-- 다음 그룹 -->
				<% if (pageHelper.getNextPage() > 0) { %>
				<li>
					<a href="list.jsp?page=<%=pageHelper.getNextPage()%>&keyword=<%=keyword%>"><span aria-hidden="true">&raquo;</span></a>
				</li>
				<% } else { %>
        		<li class='disabled'>
        			<a href="#"><span aria-hidden="true">&raquo;</span></a>
        		</li>
				<% } %>
			</ul>
		</nav>
		
	</div>
	<%@ include file="/inc/footer.jsp" %>
</body>
</html>