package study.jsp.mysite.dao;

import java.util.List;
import study.jsp.mysite.model.BBSDocument;

/** 게시판 글 관리 기능 정의 */
public interface BBSDocumentDao {

	/**
	 * 게시물을 작성한다.
	 * @param document	- 게시물 작성 정보 
	 * @return int
	 */
	public int doWrite(BBSDocument document);

	/**
	 * 게시물을 수정한다.
	 * @param document	- 게시물 수정 정보
	 * @return int
	 */
	public int doEdit(BBSDocument document);
	
	/**
	 * 게시물을 삭제한다.
	 * - 게시물의 일련번호와 비밀번호를 필요로 하기 때문에
	 *   Beans의 객체를 파라미터로 받는다.
	 * @param document - 게시물 삭제 정보
	 * @return int
	 */
	public int doDelete(BBSDocument document);
	
	/**
	 * 게시물의 전체 수를 조회한다.
	 * 검색조건이 있다면 검색된 게시물의 수를 조회한다.
	 * @param document - 검색어를 포함한 데이터 객체
	 * @return int
	 */
	public int getCount(BBSDocument document);
	
	/**
	 * 특정 게시물의 데이터를 조회한다.
	 * @param id
	 * @return BBSDocument
	 */
	public BBSDocument getDocumentItem(int id);
	
	/**
	 * 게시물 목록을 조회한다.
	 * @return List<BBSDocument>
	 */
	public List<BBSDocument> getDocumentList();
	
	/**
	 * 게시물 목록과 첨부파일 하나를 함께 조회한다.
	 * @return List(BBSDocument>
	 */
	public List<BBSDocument> getGalleryList(BBSDocument document);

	/**
	 * 이전 글을 조회한다.
	 * @param id - 현재 글 일련번호
	 * @return BBSDocument
	 */
	public BBSDocument getPrevItem(BBSDocument document);

	/**
	 * 다음 글을 조회한다.
	 * @param id - 현재 글 일련번호
	 * @return BBSDocument
	 */
	public BBSDocument getNextItem(BBSDocument document);

	/**
	 * 조회수를 1증가 시킨다.
	 * @param id - 현재 글 일련번호
	 * @return BBSDocument
	 */
	public int doUpdateHit(int id);
	
	/**
	 * 게시물의 비밀번호를 검사한다.
	 */
	public int checkPassword(BBSDocument document);
}
