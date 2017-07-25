package study.jsp.mysite.model;

/** 게시물에 대한 데이터 구조 */
public class BBSDocument {
	private int id;				// 게시물 일련번호
	private String bbsType;		// 게시판 종류를 판단하는 값
	private int memberId;		// 작성자 회원 일련번호 - 참조키
	private String writerName;	// 작성자 이름
	private String writerPw;	// 작성자 비밀번호
	private String email;		// 이메일 주소
	private String subject;		// 글 제목
	private String content;		// 본문 내용
	private String ipAddress;	// 작성자 아이피 주소
	private int hit;			// 조회수
	private String regDate;		// 등록일시
	private String editDate;	// 수정일시
	
	private String keyword;		// 검색어 --> 자주 사용하지 않으므로, 생성자에서는 제외.
	private String file;		// 첨부파일 --> 자주 사용하지 않으므로, 생성자에서는 제외.

	private int limitStart;		// MySQL의 Limit 시작 위치
	private int listCount;		// 한 페이지에 보여질 목록 수

	/** 기본 생성자, 생성자, getter, setter, toString() */
	public BBSDocument() {
		super();
	}

	public BBSDocument(int id, String bbsType, int memberId, String writerName,
			String writerPw, String email, String subject, String content,
			String ipAddress, int hit, String regDate, String editDate) {
		super();
		this.id = id;
		this.bbsType = bbsType;
		this.memberId = memberId;
		this.writerName = writerName;
		this.writerPw = writerPw;
		this.email = email;
		this.subject = subject;
		this.content = content;
		this.ipAddress = ipAddress;
		this.hit = hit;
		this.regDate = regDate;
		this.editDate = editDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

	public String getWriterName() {
		return writerName;
	}

	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}

	public String getWriterPw() {
		return writerPw;
	}

	public void setWriterPw(String writerPw) {
		this.writerPw = writerPw;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	public int getHit() {
		return hit;
	}

	public void setHit(int hit) {
		this.hit = hit;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getEditDate() {
		return editDate;
	}

	public void setEditDate(String editDate) {
		this.editDate = editDate;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public int getLimitStart() {
		return limitStart;
	}

	public void setLimitStart(int limitStart) {
		this.limitStart = limitStart;
	}

	public int getListCount() {
		return listCount;
	}

	public void setListCount(int listCount) {
		this.listCount = listCount;
	}

	public String getBbsType() {
		return bbsType;
	}

	public void setBbsType(String bbsType) {
		this.bbsType = bbsType;
	}
	
	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	@Override
	public String toString() {
		return "BBSDocument [id=" + id + ", bbsType=" + bbsType +", memberId=" + memberId
				+ ", writerName=" + writerName + ", writerPw=" + writerPw
				+ ", email=" + email + ", subject=" + subject + ", content="
				+ content + ", ipAddress=" + ipAddress + ", hit=" + hit
				+ ", regDate=" + regDate + ", editDate=" + editDate + "]";
	}

}
