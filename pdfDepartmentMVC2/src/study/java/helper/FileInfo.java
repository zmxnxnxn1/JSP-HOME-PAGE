package study.java.helper;

public class FileInfo {
	private String fieldName; 	// <input type="file">의 name속성
	private String orginName; 	// 원본 파일 이름
	private String fileDir; 	// 파일이 저장되어 있는 서버상의 경로
	private String fileName; 	// 서버상의 파일 이름
	private String contentType; // 파일의 형식
	private long fileSize; 		// 파일의 용량

	// 생성자 + getter + setter + toString() 추가
	public FileInfo(String fieldName, String orginName, String fileDir,
			String fileName, String contentType, long fileSize) {
		super();
		this.fieldName = fieldName;
		this.orginName = orginName;
		this.fileDir = fileDir;
		this.fileName = fileName;
		this.contentType = contentType;
		this.fileSize = fileSize;
	}

	public String getFieldName() {
		return fieldName;
	}

	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getOrginName() {
		return orginName;
	}

	public void setOrginName(String orginName) {
		this.orginName = orginName;
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

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	@Override
	public String toString() {
		return "FileInfo [fieldName=" + fieldName + ", orginName=" + orginName
				+ ", fileDir=" + fileDir + ", fileName=" + fileName
				+ ", contentType=" + contentType + ", fileSize=" + fileSize
				+ "]";
	}

}
