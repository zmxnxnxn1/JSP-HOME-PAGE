package study.jsp.mysite.model;

public class BBSFile {
	private int id;					// ���� �Ϸù�ȣ
	private int bbsDocumentId;		// �Խù� ���� �Ϸù�ȣ - ����Ű
	private String fileDir;			// ������ ����� ���� ���
	private String fileName;		// ������ ����� �̸�
	private long fileSize;			// ���� �뷮
	private String fileType;		// ���� ����
	private String orginName;		// ���� ���ϸ�
	private String regDate;			// ����Ͻ�
	private String editDate;		// �����Ͻ�

	/** �⺻ ������, ������, getter, setter, toString() */
	public BBSFile() {
		super();
	}

	public BBSFile(int id, int bbsDocumentId, String fileDir,
			String fileName, long fileSize, String fileType, String orginName,
			String regDate, String editDate) {
		super();
		this.id = id;
		this.bbsDocumentId = bbsDocumentId;
		this.fileDir = fileDir;
		this.fileName = fileName;
		this.fileSize = fileSize;
		this.fileType = fileType;
		this.orginName = orginName;
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

	public String getFileDir() {
		return fileDir;
	}

	public void setFileDir(String fileDir) {
		this.fileDir = fileDir;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getOrginName() {
		return orginName;
	}

	public void setOrginName(String orginName) {
		this.orginName = orginName;
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
		return "BBSFile [id=" + id + ", bbsDocumentId=" + bbsDocumentId
				+ ", fileDir=" + fileDir + ", fileName=" + fileName
				+ ", fileSize=" + fileSize + ", fileType=" + fileType
				+ ", orginName=" + orginName + ", regDate=" + regDate
				+ ", editDate=" + editDate + "]";
	}

}
