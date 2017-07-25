<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="study.java.helper.WebHelper"%>
<%@ page import="study.jsp.mysite.model.Member"%>
<%
	/** 현재 페이지의 경로를 얻는다. */
	String nowUrl = request.getRequestURI();
	//out.println(nowUrl);
	
	/** 로그인을 해야만 사용할 수 있는 페이지의 목록의 배열 */
	String[] memberOnlyPage = {
			"/member/edit.jsp", 		"/member/edit_ok.jsp",
			"/member/logout.jsp", 		"/member/out.jsp"
	};
	
	/** 로그인을 한 경우는 사용할 수 없는 페이지의 목록 배열 */
	String[] guestOnlyPage = {
			"/member/find_pw_ok.jsp", 	"/member/find_pw.jsp",
			"/member/join_ok.jsp", 		"/member/join.jsp",
			"/member/login_ok.jsp"
	};
	
	/** 세션정보의 존재 여부를 획득한다.
	    이 파일은 모든 페이지에 삽입되므로, 다른 페이지들과 변수명이 중복될 경우
	    변수가 중복 선언된 것으로 간주되어 에러가 발생한다. */
	Member sessionInfo = (Member) session.getAttribute("member");
	
	if (sessionInfo == null) {
		/** 세션이 없을 경우 회원 전용 페이지는 접근 불가 */
		// 현재 페이지 경로를 페이지 목록 배열에서 찾았는지 여부
		boolean find = false;
		
		// 회원 전용 페이지에 대한 배열의 길이만큼 반복한다.
		for (int i=0; i<memberOnlyPage.length; i++) {
			// 현재 주소에서 배열의 i번째 내용이 시작되는 위치가 있다면?
			// --> 즉, 현재 주소에서 배열의 i번째 내용이 검색되었다면?
			if (nowUrl.indexOf(memberOnlyPage[i]) > -1) {
				find = true;
				break;
			}
		}
		
		if (find == true) {
			WebHelper.getInstance(request, response, out).redirect(null, "로그인 후에 이용 가능합니다.");
			return;
		}
	} else {
		/** 세션이 있을 경우 비회원 전용 페이지는 접근 불가 */
		boolean find = false;
		
		for (int i=0; i<guestOnlyPage.length; i++) {
			if (nowUrl.indexOf(guestOnlyPage[i]) > -1) {
				find = true;
				break;
			}
		}
		
		if (find == true) {
			WebHelper.getInstance(request, response, out).redirect(null, "이미 로그인 하셨습니다.");
			return;
		}
	}
%>