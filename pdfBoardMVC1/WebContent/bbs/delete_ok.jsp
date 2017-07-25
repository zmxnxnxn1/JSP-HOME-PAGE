<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="java.io.File"%>
<%@ page import="java.util.List"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.jsp.mysite.model.BBSFile"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>
<%@ include file="/inc/bbs_config.jsp"%>

<%
	/** 로그인 한 회원 정보를 얻는다. */
	int member_id = 0;
	Member myinfo = (Member) session.getAttribute("member");

	/** 파라미터 받기 */
	WebHelper helper = WebHelper.getInstance(request, response, out);
	int document_id = helper.getInt("document_id");
	String pwd = helper.getString("pwd");
	// 자신의 글을 삭제하는지 여부 - 기본값은 N
	String is_mine = helper.getString("is_mine", "N"); // delete.jsp 에서 넘어온다.
	
	// 로그인 상태이고, 자신의 글을 삭제한다면?
	if (myinfo != null && is_mine.equals("Y")) {
		// 비밀번호를 세션의 정보로 사용한다.
		pwd = myinfo.getUserPw();
		// 세션에 저장된 회원 번호를 얻는다.
		member_id = myinfo.getId();
	}
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());
	logger.debug("document_id=" + document_id);
	logger.debug("pwd=" + pwd);
	logger.debug("is_mine=" + is_mine);
	
	/** 파라미터 검사 */
	RegexHelper regex = RegexHelper.getInstance();
	
	if (document_id < 1) {
		helper.redirect(null, "게시물 일련번호가 없습니다.");
		return;
	}
	
	if (!regex.isValue(pwd)) {
		helper.redirect(null, "비밀번호를 입력하세요.");
		return;
	}
	
	/** 작성 내용을 Beans 객체로 구성 */
	// --> 게시물일련번호와 비밀번호만 설정한다.
	BBSDocument document = new BBSDocument(document_id, bbs_type, member_id, null,
			pwd, null, null, null, null, 0, null, null);
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 비밀번호 검사하기 */
	if (is_mine.equals("N")) {
		// 자신의 글이 아닌 경우 수행한다.
		int password_check = 0;
		try {
			// 데이터 조회 결과 호출
			password_check = sqlSession.selectOne(
								"BBSDocumentMapper.checkPassword", document);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
			logger.error(e.getMessage());
		}
		
		if (password_check < 1) {
			sqlSession.close();
			helper.redirect(null, "비밀번호가 맞지 않습니다.");
			return;
		}
	} else {
		// 비밀번호 검사 대신, 자신의 글이 맞는지 검사한다.
		try {
			document = sqlSession.selectOne(
							"BBSDocumentMapper.getDocumentItem", document_id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		// 조회결과가 있다면?
		if (document != null) {
			// 게시물에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
			if (document.getMemberId() != member_id) {
				sqlSession.close();
				helper.redirect(null, "직접 작성한 글이 아니므로 삭제할 수 없습니다.");
				return;
			}
		}
	}
	
	/** 첨부파일 데이터 조회해서 보관하고 있는다. */
	List<BBSFile> fileList = null;
	
	try {
		// 특정 게시물에 속한 파일정보 조회하기
		fileList = sqlSession.selectList(
						"BBSFileMapper.getFileList", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	/** DB 테이블에 저장된 파일 정보를 삭제한다. */
	try {
		// 특정 게시물에 속한 파일정보 삭제하기
		sqlSession.delete("BBSFileMapper.doDelete", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	/** 현재 게시물에 소속된 덧글을 일괄 삭제한다. */
	int comment_count = 0;
	try {
		// 특정 게시물에 속한 파일정보 삭제하기
		comment_count = sqlSession.delete("BBSCommentMapper.doDeleteAll", document_id);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	/** 본문을 삭제한다. */
	int delete_count = 0;
	try {
		// 특정 게시물에 속한 파일정보 삭제하기
		delete_count = sqlSession.delete("BBSDocumentMapper.doDelete", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	if (delete_count < 1) {
		sqlSession.close();
		helper.redirect(null, "삭제된 정보가 없습니다.");
		return;
	}
	
	// 모든 처리가 끝났으므로 저장된 데이터를 실제 반영시킨다.
	sqlSession.commit();
	
	// DB접속 해제
	sqlSession.close();
	
	/** 모든 데이터 처리가 종료되었다면 실제로 저장되어 있는 파일을 삭제한다. */
	if (fileList != null) {
		for (int i=0; i<fileList.size(); i++) {
			BBSFile info = fileList.get(i);
			
			String file_dir = info.getFileDir();	// 파일이 저장된 폴더
			String file_name = info.getFileName();	// 저장된 파일이름
			
			// 폴더와 이름을 사용한 java.io.File 객체 생성
			File file = new File(file_dir, file_name);
			
			// 파일이 실제로 존재한다면 삭제후 결과를 로그로 기록한다.
			if (file.exists()) {
				file.delete();
				logger.debug("File Delete >> " + file.getAbsolutePath());
			} else {
				logger.debug("File not Exists >> " + file.getAbsolutePath());
			}
		}
	}
	
	/** 목록 페이지로 이동 */
	helper.redirect("list.jsp", "삭제되었습니다.");
%>

