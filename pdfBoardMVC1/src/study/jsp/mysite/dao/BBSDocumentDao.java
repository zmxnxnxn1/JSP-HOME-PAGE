package study.jsp.mysite.dao;

import java.util.List;
import study.jsp.mysite.model.BBSDocument;

/** �Խ��� �� ���� ��� ���� */
public interface BBSDocumentDao {

	/**
	 * �Խù��� �ۼ��Ѵ�.
	 * @param document	- �Խù� �ۼ� ���� 
	 * @return int
	 */
	public int doWrite(BBSDocument document);

	/**
	 * �Խù��� �����Ѵ�.
	 * @param document	- �Խù� ���� ����
	 * @return int
	 */
	public int doEdit(BBSDocument document);
	
	/**
	 * �Խù��� �����Ѵ�.
	 * - �Խù��� �Ϸù�ȣ�� ��й�ȣ�� �ʿ�� �ϱ� ������
	 *   Beans�� ��ü�� �Ķ���ͷ� �޴´�.
	 * @param document - �Խù� ���� ����
	 * @return int
	 */
	public int doDelete(BBSDocument document);
	
	/**
	 * �Խù��� ��ü ���� ��ȸ�Ѵ�.
	 * �˻������� �ִٸ� �˻��� �Խù��� ���� ��ȸ�Ѵ�.
	 * @param document - �˻�� ������ ������ ��ü
	 * @return int
	 */
	public int getCount(BBSDocument document);
	
	/**
	 * Ư�� �Խù��� �����͸� ��ȸ�Ѵ�.
	 * @param id
	 * @return BBSDocument
	 */
	public BBSDocument getDocumentItem(int id);
	
	/**
	 * �Խù� ����� ��ȸ�Ѵ�.
	 * @return List<BBSDocument>
	 */
	public List<BBSDocument> getDocumentList();
	
	/**
	 * �Խù� ��ϰ� ÷������ �ϳ��� �Բ� ��ȸ�Ѵ�.
	 * @return List(BBSDocument>
	 */
	public List<BBSDocument> getGalleryList(BBSDocument document);

	/**
	 * ���� ���� ��ȸ�Ѵ�.
	 * @param id - ���� �� �Ϸù�ȣ
	 * @return BBSDocument
	 */
	public BBSDocument getPrevItem(BBSDocument document);

	/**
	 * ���� ���� ��ȸ�Ѵ�.
	 * @param id - ���� �� �Ϸù�ȣ
	 * @return BBSDocument
	 */
	public BBSDocument getNextItem(BBSDocument document);

	/**
	 * ��ȸ���� 1���� ��Ų��.
	 * @param id - ���� �� �Ϸù�ȣ
	 * @return BBSDocument
	 */
	public int doUpdateHit(int id);
	
	/**
	 * �Խù��� ��й�ȣ�� �˻��Ѵ�.
	 */
	public int checkPassword(BBSDocument document);
}
