package study.jsp.mysite.dao;

import study.jsp.mysite.model.Member;

public interface MemberDao {
	
	/**
	 * ȸ�������� ó���Ѵ�.--> INSERT ����
	 * @param 	member 		������ ���� ��� �ִ� Member Ŭ������ ��ü
	 * @return	int 		����� ���� Primary Key��
	 */
	public int doJoin(Member member);
	
	/**
	 * �Ķ���ͷ� ���޵� ���̵�� ������ �������� ���� ī��Ʈ �Ѵ�.
	 * --> �ߺ��˻� �� 
	 * @param 	userId 		ȸ�� ���̵�
	 * @return	int
	 */
	public int getUserIdCount(String userId);
	
	/**
	 * �Ķ���ͷ� ���޵� �̸��ϰ� ������ �������� ���� ī��Ʈ �Ѵ�.
	 * --> �ߺ��˻� ��
	 * @param 	email		�̸��� �ּ�
	 * @return	int
	 */
	public int getEmailCount(String email);
	
	/**
	 * �α����� ó���Ѵ�.
	 * @param member		���̵�� ��й�ȣ�� �����ϰ� �ִ� MemberŬ������ ��ü
	 * @return Member
	 */
	public Member doLogin(Member Member);
	
	/**
	 * Ż�� ó���Ѵ�.
	 * @param id		ȸ���� �Ϸù�ȣ
	 * @return int
	 */
	public int doOut(int id);
	
	/**
	 * �̸��� �ּҿ� ���ؼ� ��й�ȣ�� �����Ѵ�.
	 * @param member		�̸��ϰ� ��й�ȣ�� �����ϰ� �ִ� MemberŬ������ ��ü
	 * @return int
	 */
	public int changePasswordByEmail(Member member);
	
	/**
	 * ȸ�� ������ ��ȸ�Ѵ�.
	 * @param id 		ȸ�� �Ϸù�ȣ
	 * @return Member
	 */
	public Member getInfo(int id);
	
	/**
	 * ȸ�� ������ �����Ѵ�.
	 * @param member 		����� ȸ������ �����ϰ� �ִ� Member Ŭ������ ��ü
	 * @return int
	 */
	public int doEdit(Member member);
	
}



