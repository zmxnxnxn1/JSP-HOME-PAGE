<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="javax.activation.MimetypesFileTypeMap"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>

<%
	// 파라미터 받기
	// --> 서버상에 저장된 파일 경로를 파라미터로 받는다.
	WebHelper helper = WebHelper.getInstance(request, response, out);
	String file = helper.getString("file");
	String orgin_name = helper.getString("orgin_name");
	int img_size = helper.getInt("img_size");

	// 처리파라미터가 없다면 처리 종료
	if (file == null) {
		return;
	}

	// 파일의 존재여부 검사
	File f = new File(file);

	// 파일이 없으면 다운로드 처리 실패
	if (!f.exists()) {
		return;
	}
	
	// 파일의 크기 추출하기
	long size = f.length();
	// 파일의 이름 추출하기
	String name = f.getName();
	// 파일형식 얻기 (업로드 정보에서 추출했던 contentType과 같은 값)
	// --> javax.activation.MimetypesFileTypeMap
	MimetypesFileTypeMap map = new MimetypesFileTypeMap();
	String fileType = map.getContentType(f);
	
	/** 이미지 크기가 요청되었다면 썸네일을 생성한다. */
	if (img_size > 0) {
		// 생성될 썸네일의 파일이름
		name = "thumb_" + name;
		// 이미지가 위치한 폴더
		String dir = f.getParent();
		
		// 생성할 파일에 대한 객체
		File thumb = new File(dir, name);
		
		// 파일이 존재하지 않는다면?
		if (!thumb.exists()) {
			// 썸네일을 생성한다.
			boolean result = helper.createThumbnail(
					f.getAbsolutePath(), thumb.getAbsolutePath(), img_size);
			
			if (!result) {
				return;
			}
		}
		
		// 다운로드를 위한 대상 f 객체를 변경한다.
		f = null;
		f = thumb;
	}
	
	// 파라미터로 받은 원본 이름이 있다면 파일의 이름을 파라미터 값으로 변경한다.
	// --> 다운로드 되는 파일의 이름이 이 값으로 사용된다.
	if (orgin_name != null) {
		name = orgin_name;
	}

	// 파일다운로드
	InputStream is = null;
	OutputStream os = null;
	
	try {
		/** 스트림을 통한 파일의 바이너리 출력 처리 */
		// 파일 읽기 스트림을 생성한다.
		is = new FileInputStream(f);

		// 파일의 내용을 담기 위한 byte 배열
		byte b[] = new byte[(int) size];
		
		// 파일 읽기
		is.read(b);

		// 다른 데이터와 섞이지 않도록 out객체의 버퍼를 비운다.
		out.clear();
		
		// 다른 데이터와 섞이지 않도록 response객체를 리셋한다.
		response.reset();
		
		// 파일형식 정보 설정
		response.setHeader("Content-Type", fileType + "; charset=UTF-8");
		
		// 파일의 이름 설정 (인코딩 필요함)
		String encFileName = URLEncoder.encode(name, "UTF-8");
		response.setHeader("Content-Disposition",
				"attachment; filename=" + encFileName + ";");
		
		// 파일의 용량 설정
		response.setContentLength((int) size);
		
		// 출력객체를 생성해서 파일의 데이터를 현재 JSP에 출력한다.
		os = response.getOutputStream();
		os.write(b);
	} catch (Exception e) {
		/** 예외가 발생한 경우의 처리 (ex: Log4j를 사용한 로그 기록)
		    여기서는 생략한다. */
	} finally {
		/** 스트림을 닫는다. */
		if (is != null) {
			try {
				is.close();
			} catch (Exception e) {}
		}
		
		if (os != null) {
			try {
				os.close();
			} catch (Exception e) {}
		}
	} // end try ~ catch
%>