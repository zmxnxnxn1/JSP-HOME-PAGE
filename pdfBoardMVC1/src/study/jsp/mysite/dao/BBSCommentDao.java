package study.jsp.mysite.dao;

import java.util.List;

import study.jsp.mysite.model.BBSComment;

/** 특정 게시물에 대한 덧글 관리 기능 정의 */
public interface BBSCommentDao {

	/**
	 * 덧글 작성
	 * @param comment - 저장할 덧글 정보
	 * @return int
	 */
	public int doWrite(BBSComment comment);

	/**
	 * 덧글 수정
	 * @param comment - 수정할 덧글 정보
	 * @return int
	 */
	public int doEdit(BBSComment comment);
	
	/**
	 * 덧글 삭제
	 * @param comment - 삭제할 덧글 정보(일련번호+비밀번호)
	 * @return int
	 */
	public int doDelete(BBSComment comment);

	/**
	 * 덧글 하나의 내용을 조회한다.
	 * @param id - 덧글 일련번호
	 * @return BBSComment
	 */
	public BBSComment getCommentItem(int id);
	
	/**
	 * 특정 게시물에 속한 덧글 목록을 조회한다.
	 * @param bbsDocumentId - 게시물 일련번호
	 * @return List<BBSComment>
	 */
	public List<BBSComment> getCommentList(int bbsDocumentId);
	
	/**
	 * 덧글의 비밀번호를 검사한다.
	 */
	public int checkPassword(BBSComment document);
	
	/**
	 * 특정 게시물에 소속된 덧글을 일괄적으로 삭제한다.
	 * @param bbsDocumentId - 게시물 일련번호
	 * @return int
	 */
	public int deDeleteAll(int bbsDocumentId);
	
}
