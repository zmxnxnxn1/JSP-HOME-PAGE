package study.jsp.mysite.model;

/** �Խù��� ���� ������ ���� */
public class BBSDocument {
	private int id;				// �Խù� �Ϸù�ȣ
	private String bbsType;		// �Խ��� ������ �Ǵ��ϴ� ��
	private int memberId;		// �ۼ��� ȸ�� �Ϸù�ȣ - ����Ű
	private String writerName;	// �ۼ��� �̸�
	private String writerPw;	// �ۼ��� ��й�ȣ
	private String email;		// �̸��� �ּ�
	private String subject;		// �� ����
	private String content;		// ���� ����
	private String ipAddress;	// �ۼ��� ������ �ּ�
	private int hit;			// ��ȸ��
	private String regDate;		// ����Ͻ�
	private String editDate;	// �����Ͻ�
	
	private String keyword;		// �˻��� --> ���� ������� �����Ƿ�, �����ڿ����� ����.
	private String file;		// ÷������ --> ���� ������� �����Ƿ�, �����ڿ����� ����.

	private int limitStart;		// MySQL�� Limit ���� ��ġ
	private int listCount;		// �� �������� ������ ��� ��

	/** �⺻ ������, ������, getter, setter, toString() */
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
