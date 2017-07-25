package study.jsp.mysite.dao;

import java.util.List;
import study.jsp.mysite.model.BBSFile;

/** 특정 게시물에 대한 파일 관리 기능 정의 */
public interface BBSFileDao {

	/**
	 * 첨부파일 데이터를 DB에 등록한다.
	 * @param file	- 파일정보에 대한 Beans 객체
	 * @return int
	 */
	public int doInsert(BBSFile file);
	
	/**
	 * 첨부파일 데이터를 삭제한다.
	 * @param int 	- 파일 정보의 일련번호
	 * @return int
	 */
	public int doDelete(int id);
	
	/**
	 * 첨부파일 하나의 정보를 조회한다.
	 * @param id	- 파일 정보의 일련번호
	 * @return BBSFile
	 */
	public BBSFile getFileItem(int id);
	
	/**
	 * 특정 게시물에 대한 첨부파일 목록을 조회한다.
	 * @param bbsDocumentId - 파일이 속한 게시물의 일련번호 
	 * @return List<BBSFile>
	 */
	public List<BBSFile> getFileList(int bbsDocumentId);
	
	/**
	 * 특정 파일의 데이터를 삭제한다.
	 * @param int 	- 파일 일련번호
	 * @return int
	 */
	public int doDeleteItem(int id);
}
