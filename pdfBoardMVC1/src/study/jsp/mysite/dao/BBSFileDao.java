package study.jsp.mysite.dao;

import java.util.List;
import study.jsp.mysite.model.BBSFile;

/** Ư�� �Խù��� ���� ���� ���� ��� ���� */
public interface BBSFileDao {

	/**
	 * ÷������ �����͸� DB�� ����Ѵ�.
	 * @param file	- ���������� ���� Beans ��ü
	 * @return int
	 */
	public int doInsert(BBSFile file);
	
	/**
	 * ÷������ �����͸� �����Ѵ�.
	 * @param int 	- ���� ������ �Ϸù�ȣ
	 * @return int
	 */
	public int doDelete(int id);
	
	/**
	 * ÷������ �ϳ��� ������ ��ȸ�Ѵ�.
	 * @param id	- ���� ������ �Ϸù�ȣ
	 * @return BBSFile
	 */
	public BBSFile getFileItem(int id);
	
	/**
	 * Ư�� �Խù��� ���� ÷������ ����� ��ȸ�Ѵ�.
	 * @param bbsDocumentId - ������ ���� �Խù��� �Ϸù�ȣ 
	 * @return List<BBSFile>
	 */
	public List<BBSFile> getFileList(int bbsDocumentId);
	
	/**
	 * Ư�� ������ �����͸� �����Ѵ�.
	 * @param int 	- ���� �Ϸù�ȣ
	 * @return int
	 */
	public int doDeleteItem(int id);
}
