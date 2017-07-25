package study.jsp.mysite.model;

/** 덧글에 대한 데이터 구조 */
public class BBSComment {
	private int id;					// 덧글 일련번호
	private int bbsDocumentId;		// 본문 일련번호 - 참조키
	private int memberId;			// 작성자 회원 일련번호 - 참조키
	private String writerName;		// 작성자 이름
	private String writerPw;		// 작성자 비밀번호
	private String email;			// 이메일 주소
	private String content;			// 덧글 내용
	private String ipAddress;		// 작성자 아이피 주소
	private String regDate;			// 등록일시
	private String editDate;		// 변경일시

	/** 기본 생성자, 생성자, getter, setter, toString() */
	public BBSComment() {
		super();
	}

	public BBSComment(int id, int bbsDocumentId, int memberId,
			String writerName, String writerPw, String email, String content,
			String ipAddress, String regDate, String editDate) {
		super();
		this.id = id;
		this.bbsDocumentId = bbsDocumentId;
		this.memberId = memberId;
		this.writerName = writerName;
		this.writerPw = writerPw;
		this.email = email;
		this.content = content;
		this.ipAddress = ipAddress;
		this.regDate = regDate;
		this.editDate = editDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBbsDocumentId() {
		return bbsDocumentId;
	}

	public void setBbsDocumentId(int bbsDocumentId) {
		this.bbsDocumentId = bbsDocumentId;
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

	@Override
	public String toString() {
		return "BBSComment [id=" + id + ", bbsDocumentId=" + bbsDocumentId
				+ ", memberId=" + memberId + ", writerName=" + writerName
				+ ", writerPw=" + writerPw + ", email=" + email + ", content="
				+ content + ", ipAddress=" + ipAddress + ", regDate=" + regDate
				+ ", editDate=" + editDate + "]";
	}

}
