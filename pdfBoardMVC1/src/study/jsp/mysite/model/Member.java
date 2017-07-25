package study.jsp.mysite.model;

/** 회원 테이블을 표현하는 Java Beans */
public class Member {
	private int id;
	private String userId;
	private String userPw;
	private String userName;
	private String email;
	private String tel;
	private String postcode;
	private String addr1;
	private String addr2;
	private String regDate;
	private String editDate;
	
	// 회원정보 변경시 사용할 새로운 비밀번호
	// --> 평상시에는 사용하지 않는 값이므로 생성자에서의 추가는 생략한다.
	// --> 변수에 접근하기 위해서 getter, setter는 추가한다.
	private String newUserPw;

	/** 기본 생성자 + 생성자 + getter,setter + toString() 추가 */
	public Member() {
		super();
	}

	public Member(int id, String userId, String userPw, String userName,
			String email, String tel, String postcode, String addr1,
			String addr2, String regDate, String editDate) {
		super();
		this.id = id;
		this.userId = userId;
		this.userPw = userPw;
		this.userName = userName;
		this.email = email;
		this.tel = tel;
		this.postcode = postcode;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.regDate = regDate;
		this.editDate = editDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
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

	public String getNewUserPw() {
		return newUserPw;
	}

	public void setNewUserPw(String newUserPw) {
		this.newUserPw = newUserPw;
	}

	@Override
	public String toString() {
		return "Member [id=" + id + ", userId=" + userId + ", userPw=" + userPw
				+ ", userName=" + userName + ", email=" + email + ", tel="
				+ tel + ", postcode=" + postcode + ", addr1=" + addr1
				+ ", addr2=" + addr2 + ", regDate=" + regDate + ", editDate="
				+ editDate + "]";
	}

}
