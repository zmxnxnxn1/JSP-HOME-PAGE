package study.jsp.mysite.dao;

import java.util.List;

import study.jsp.mysite.model.BBSComment;

/** Ư�� �Խù��� ���� ���� ���� ��� ���� */
public interface BBSCommentDao {

	/**
	 * ���� �ۼ�
	 * @param comment - ������ ���� ����
	 * @return int
	 */
	public int doWrite(BBSComment comment);

	/**
	 * ���� ����
	 * @param comment - ������ ���� ����
	 * @return int
	 */
	public int doEdit(BBSComment comment);
	
	/**
	 * ���� ����
	 * @param comment - ������ ���� ����(�Ϸù�ȣ+��й�ȣ)
	 * @return int
	 */
	public int doDelete(BBSComment comment);

	/**
	 * ���� �ϳ��� ������ ��ȸ�Ѵ�.
	 * @param id - ���� �Ϸù�ȣ
	 * @return BBSComment
	 */
	public BBSComment getCommentItem(int id);
	
	/**
	 * Ư�� �Խù��� ���� ���� ����� ��ȸ�Ѵ�.
	 * @param bbsDocumentId - �Խù� �Ϸù�ȣ
	 * @return List<BBSComment>
	 */
	public List<BBSComment> getCommentList(int bbsDocumentId);
	
	/**
	 * ������ ��й�ȣ�� �˻��Ѵ�.
	 */
	public int checkPassword(BBSComment document);
	
	/**
	 * Ư�� �Խù��� �Ҽӵ� ������ �ϰ������� �����Ѵ�.
	 * @param bbsDocumentId - �Խù� �Ϸù�ȣ
	 * @return int
	 */
	public int deDeleteAll(int bbsDocumentId);
	
}
