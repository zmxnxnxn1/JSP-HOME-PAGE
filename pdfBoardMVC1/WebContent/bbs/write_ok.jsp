<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.java.helper.FileInfo"%>
<%@ page import="study.jsp.mysite.model.BBSFile"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>

<%@ include file="/inc/init.jsp" %>
<%@ include file="/inc/bbs_config.jsp"%>

<%
	/** 회원 일련번호를 획득하기 위해서 세션데이터 추출하기 */
	Member loginInfo = (Member) session.getAttribute("member");
	int member_id = 0;
	
	if (loginInfo != null) {
		member_id = loginInfo.getId();
	}

	/** WebHelper를 사용한 업로드 처리 */
	WebHelper helper = WebHelper.getInstance(request, response, out);

	boolean upload_ok = helper.multipartRequest();
	
	if (!upload_ok) {
		helper.redirect(null, "Multipart/form-data 형식이 아닙니다.");
		return;
	}
	
	/** 업로드를 통해 구분된 파라미터 컬렉션 받기 */
	List<FileInfo> fileList = helper.getFileList();
	Map<String, String> paramMap = helper.getParamMap();
	
	/** 컬렉션에서 파라미터 추출하기 */
	String writer_name = paramMap.get("writer_name");
	String writer_pw = paramMap.get("writer_pw");
	String email = paramMap.get("email");
	String subject = paramMap.get("subject");
	String content = paramMap.get("content");
	
	// 로그인 중이라면 이름, 비번, 이메일은 세션정보에서 채워 넣는다.
	if (loginInfo != null) {
		writer_name = loginInfo.getUserName();
		writer_pw = loginInfo.getUserPw();
		email = loginInfo.getEmail();
	}

	// 접속자의 IP주소
	String ip_address = request.getRemoteAddr();
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());

	logger.debug("writer_name=" + writer_name);
	logger.debug("writer_pw=" + writer_pw);
	logger.debug("email=" + email);
	logger.debug("subject=" + subject);
	logger.debug("content=" + content);
	logger.debug("ip_address=" + ip_address);
	
	
	for (int i=0; i<fileList.size(); i++) {
		logger.debug("FileInfo[" + i + "]=> " + fileList.get(i).toString());
	}
	
	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();

	if (!regex.isValue(writer_name)) {
		helper.redirect(null, "작성자 이름을 입력하세요.");
		return;
	}

	if (!regex.isValue(writer_pw)) {
		helper.redirect(null, "비밀번호를 입력하세요.");
		return;
	}

	if (!regex.isValue(email)) {
		helper.redirect(null, "이메일을 입력하세요.");
		return;
	}

	if (!regex.isValue(subject)) {
		helper.redirect(null, "제목을 입력하세요.");
		return;
	}

	/*if (!regex.isValue(content)) {
		helper.redirect(null, "내용을 입력하세요.");
		return;
	}*/
	
	/** 작성 내용을 Beans 객체로 구성 */
	// --> 게시물일련번호와 조회수는 0으로, 날짜는 null로 설정한다.
	// --> 로그인 한 경우 회원 일련변호는 세션에서 추출한 값으로 설정된다.
	BBSDocument document = new BBSDocument(0, bbs_type, member_id, writer_name,
			writer_pw, email, subject, content, ip_address, 0, null, null);
	
	/** 데이터베이스 접속하기 */
	SqlSessionFactory sqlSessionFactory = MyBatisConnectionFactory
			.getSqlSessionFactory();
	SqlSession sqlSession = sqlSessionFactory.openSession();
	
	/** 게시물 데이터 저장하기 */
	// 저장 후 리턴받을 게시물 일련번호 
	int document_id = 0;
	
	try {
		// 데이터 저장하기
		sqlSession.insert("BBSDocumentMapper.doWrite", document);
		// 새로 생성된 PK는 Beans에 설정된다.
		document_id = document.getId();
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	} finally {
		// 아직 파일 등록처리가 남아 있으므로, 접속을 종료하지 않는다.
	}
	
	// 저장에 실패하였다면?
	if (document_id < 1) {
		sqlSession.close();
		helper.redirect(null, "게시물 저장에 실패했습니다.");
		return;
	}
	
	/** 첨부파일 데이터 저장하기 */
	// 모든 첨부파일 저장에 성공했는지 여부
	boolean is_upload_ok = true;
	
	// 업로드 된 파일 수 만큼 반복한다. 업로드 된 데이터가 없다면 반복을 생략할 것이다.
	for (int i=0; i<fileList.size(); i++) {
		FileInfo f = fileList.get(i);
		
		BBSFile file = new BBSFile(0, document_id, f.getFileDir(),
				f.getFileName(), f.getFileSize(), f.getContentType(), 
				f.getOrginName(), null, null);
		
		int file_id = 0;
		try {
			// 데이터 저장하기
			file_id = sqlSession.insert("BBSFileMapper.doInsert", file);
		} catch (Exception e) {
			// 에러가 난 경우 처리할 내용이 있다면 구현한다.
			logger.error(e.getMessage());
		} finally {
			// 아직 파일 등록처리가 남아 있으므로, 접속을 종료하지 않는다.
		}
		
		// 데이터 저장에 실패했다면 is_upload_ok에 실패를 의미하는 false를 지정하고 반복을 중단한다.
		if (file_id < 1) {
			is_upload_ok = false;
			break;
		}
	}
	
	// 최종 업로드 결과가 실패라면?
	if (is_upload_ok == false) {
		sqlSession.close();
		helper.redirect(null, "파일 데이터 저장에 실패했습니다.");
		return;
	}
	
	// 모든 처리가 끝났으므로 저장된 데이터를 실제 반영시킨다.
	sqlSession.commit();
	
	// DB접속 해제
	sqlSession.close();
	
	// 읽기 페이지로 이동 > 읽을 대상을 지정하기 위해서 document_id값을 전달한다.
	String url = "read.jsp?document_id=" + document_id;
	helper.redirect(url, null);
%>
