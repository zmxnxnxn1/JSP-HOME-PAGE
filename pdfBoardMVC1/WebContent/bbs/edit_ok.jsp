<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.java.helper.RegexHelper"%>
<%@ page import="study.java.helper.FileInfo"%>
<%@ page import="study.jsp.mysite.model.BBSFile"%>
<%@ page import="study.jsp.mysite.model.BBSDocument"%>
<%@ page import="study.jsp.mysite.MyBatisConnectionFactory"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
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

	/** WebHelper를 사용한 Multipart 데이터 처리 */
	WebHelper helper = WebHelper.getInstance(request, response, out);

	boolean upload_ok = helper.multipartRequest();
	
	if (!upload_ok) {
		helper.redirect(null, "Multipart/form-data 형식이 아닙니다.");
		return;
	}
	
	/** 파라미터 컬렉션 받기 */
	List<FileInfo> fileList = helper.getFileList();
	Map<String, String> paramMap = helper.getParamMap();
	
	/** 컬렉션에서 파라미터 추출하기 */
	// 파라미터로 전달되는 모든 값들은 String 형식이므로 게시물 일련번호도 문자열로 받는다.
	String document_id_str = paramMap.get("document_id");
	String writer_name = paramMap.get("writer_name");
	String writer_pw = paramMap.get("writer_pw");
	String email = paramMap.get("email");
	String subject = paramMap.get("subject");
	String content = paramMap.get("content");

	// 접속자의 IP주소
	String ip_address = request.getRemoteAddr();
	
	// 체크박스로 전달되는 삭제 할 파일 목록
	String file_delete = paramMap.get("file_delete");
	
	// 자신의 글을 수정하는지 여부
	String is_mine = paramMap.get("is_mine");
	
	if (is_mine == null) {
		is_mine = "N";
	}
	
	// 로그인 상태이고, 자신의 글을 수정한다면?
	if (myinfo != null && is_mine.equals("Y")) {
		// 기본정보를 세션의 정보로 사용한다.
		writer_name = myinfo.getUserName();
		writer_pw = myinfo.getUserPw();
		email = myinfo.getEmail();
		// 세션에 저장된 회원 번호를 얻는다.
		member_id = myinfo.getId();
	}
	
	/** 전달된 파라미터에 대한 로그 기록하기 */
	Logger logger = LogManager.getLogger(request.getRequestURI());

	logger.debug("is_mine=" + is_mine);
	logger.debug("document_id=" + document_id_str);
	logger.debug("writer_name=" + writer_name);
	logger.debug("writer_pw=" + writer_pw);
	logger.debug("email=" + email);
	logger.debug("subject=" + subject);
	logger.debug("content=" + content);
	logger.debug("ip_address=" + ip_address);

	// 삭제할 대상에 대한 로그 기록
	logger.debug("file_delete=" + file_delete);
	
	// 새로 추가된 파일에 대한 로그 기록
	for (int i=0; i<fileList.size(); i++) {
		logger.debug("FileInfo[" + i + "]=> " + fileList.get(i).toString());
	}
	
	
	/** 필수 값 검사 */
	RegexHelper regex = RegexHelper.getInstance();
	
	// 게시물 일련번호가 숫자 형식인지를 검사한 뒤, int형으로 변환한다.
	// --> Beans에 전달하기 위함
	int document_id = 0;
	if (!regex.isNum(document_id_str)) {
		helper.redirect(null, "게시물 일련번호가 올바르지 않습니다.");
		return;
	} else {
		document_id = Integer.parseInt(document_id_str);
	}

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
	BBSDocument document = new BBSDocument(document_id, bbs_type, member_id, writer_name,
			writer_pw, email, subject, content, ip_address, 0, 
			null, null);

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
		BBSDocument saved_document = null;
		try {
			saved_document = sqlSession.selectOne(
							"BBSDocumentMapper.getDocumentItem", document_id);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		// 조회결과가 없다면?
		if (saved_document == null) {
			sqlSession.close();
			helper.redirect(null, "게시물 조회에 실패했습니다.");
			return;
		}
		
		// 게시물에 저장된 회원 번호와 현재 내 세션의 회원번호를 비교한다.
		if (saved_document.getMemberId() != member_id) {
			sqlSession.close();
			helper.redirect(null, "직접 작성한 글이 아니므로 삭제할 수 없습니다.");
			return;
		}
	}
	
	/** 게시물 데이터 수정하기 */
	// 저장 후 리턴받을 결과값
	int update_count = 0;
	
	try {
		// 데이터 수정하기
		update_count = sqlSession.update(
							"BBSDocumentMapper.doEdit", document);
	} catch (Exception e) {
		logger.error(e.getMessage());
	}
	
	// 실패하였다면?
	if (update_count < 1) {
		sqlSession.close();
		helper.redirect(null, "수정된 데이터가 없습니다.");
		return;
	}
	
	/** 첨부파일 데이터 조회 */
	List<BBSFile> savedFileList = null;
	
	try {
		// 특정 게시물에 속한 파일정보 조회하기
		savedFileList = sqlSession.selectList(
						"BBSFileMapper.getFileList", document_id);
	} catch (Exception e) {
		// 에러가 난 경우 처리할 내용이 있다면 구현한다.
		logger.error(e.getMessage());
	}
	
	/** 업로드 된 파일 목록과 삭제 대상이 있다면? */
	if (savedFileList != null && file_delete != null) {
		// 체크박스의 선택값이 콤마(,)로 구분되어 있으므로 -
		// 배열로 변환한다.
		String[] delete_list = file_delete.split(",");
		
		// 삭제 대상의 수 만큼 반복
		for (int i=0; i<delete_list.length; i++) {
			// 삭제 대상의 일련번호 하나를 숫자로 형변환 하여 추출한다.
			int delete_target_id = Integer.parseInt(delete_list[i]);
			
			// 업로드 된 파일 목록 중에서 일치하는 데이터를 찾는다.
			for (int j=0; j<savedFileList.size(); j++) {
				BBSFile item = savedFileList.get(j);
				
				// i 번째 삭제 대상의 일련번호와 일치한다면?
				if (item.getId() == delete_target_id) {
					// 1) 파일이 저장된 디렉토리 경로와 파일명 추출
					String dir = item.getFileDir();
					String name = item.getFileName();
					
					// 2) 파일 객체로 생성 후, 존재 여부에 따라 삭제
					File f = new File(dir, name);
					
					if (f.exists()) {
						f.delete();
					}
					
					// 3) 데이터베이스에서도 해당 파일의 데이터 삭제
					try {
						sqlSession.update("BBSFileMapper.doDeleteItem", delete_target_id);
					} catch (Exception e) {
						logger.error(e.getMessage());
					}
					
					// 업로드 대상에 대한 반복 처리 중단
					break;
				}
			}
		}
	}
	
	/** 신규 첨부파일 데이터 저장하기 */
	// 업로드 된 파일 수 만큼 반복한다. 업로드 된 데이터가 없다면 반복을 생략할 것이다.
	for (int i=0; i<fileList.size(); i++) {
		FileInfo f = fileList.get(i);
		
		BBSFile file = new BBSFile(0, document_id, f.getFileDir(),
				f.getFileName(), f.getFileSize(), f.getContentType(), 
				f.getOrginName(), null, null);

		try {
			// 데이터 저장하기
			sqlSession.insert("BBSFileMapper.doInsert", file);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	
	// 모든 처리가 끝났으므로 저장된 데이터를 실제 반영시킨다.
	sqlSession.commit();
	
	// DB접속 해제
	sqlSession.close();
	
	/** 읽기 페이지로 이동 > 읽을 대상을 지정하기 위해서 document_id값을 전달한다. */
	String url = "read.jsp?document_id=" + document_id;
	helper.redirect(url, null);
%>
