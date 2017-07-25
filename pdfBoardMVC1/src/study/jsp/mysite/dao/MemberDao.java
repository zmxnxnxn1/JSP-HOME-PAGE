package study.jsp.mysite.dao;

import study.jsp.mysite.model.Member;

public interface MemberDao {
	
	/**
	 * 회원가입을 처리한다.--> INSERT 수행
	 * @param 	member 		저장할 값을 담고 있는 Member 클래스의 객체
	 * @return	int 		저장된 행의 Primary Key값
	 */
	public int doJoin(Member member);
	
	/**
	 * 파라미터로 전달된 아이디와 동일한 데이터의 수를 카운트 한다.
	 * --> 중복검사 용 
	 * @param 	userId 		회원 아이디
	 * @return	int
	 */
	public int getUserIdCount(String userId);
	
	/**
	 * 파라미터로 전달된 이메일과 동일한 데이터의 수를 카운트 한다.
	 * --> 중복검사 용
	 * @param 	email		이메일 주소
	 * @return	int
	 */
	public int getEmailCount(String email);
	
	/**
	 * 로그인을 처리한다.
	 * @param member		아이디와 비밀번호를 저장하고 있는 Member클래스의 객체
	 * @return Member
	 */
	public Member doLogin(Member Member);
	
	/**
	 * 탈퇴를 처리한다.
	 * @param id		회원의 일련번호
	 * @return int
	 */
	public int doOut(int id);
	
	/**
	 * 이메일 주소에 의해서 비밀번호를 변경한다.
	 * @param member		이메일과 비밀번호를 저장하고 있는 Member클래스의 객체
	 * @return int
	 */
	public int changePasswordByEmail(Member member);
	
	/**
	 * 회원 정보를 조회한다.
	 * @param id 		회원 일련번호
	 * @return Member
	 */
	public Member getInfo(int id);
	
	/**
	 * 회원 정보를 수정한다.
	 * @param member 		변경될 회원정보 저장하고 있는 Member 클래스의 객체
	 * @return int
	 */
	public int doEdit(Member member);
	
}



