package study.jsp.simplemvc.model;

/** department 테이블 구조에 맞춘 Java Beans 생성 */
public class Department {
	private int deptno;
	private String dname;
	private String loc;
	
	// 검색어
	private String keyword;
	
	// 페이지 구현을 위한 LIMIT 시작 위치
	int limitStart;
	
	// 한 페이지에 보여질 목록 수
	int listCount;

	/** 기본 생성자 */
	public Department() {
		super();
	}
	
	public Department(int deptno, String dname, String loc) {
		super();
		this.deptno = deptno;
		this.dname = dname;
		this.loc = loc;
	}

	public int getDeptno() {
		return deptno;
	}

	public void setDeptno(int deptno) {
		this.deptno = deptno;
	}

	public String getDname() {
		return dname;
	}

	public void setDname(String dname) {
		this.dname = dname;
	}

	public String getLoc() {
		return loc;
	}

	public void setLoc(String loc) {
		this.loc = loc;
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

	@Override
	public String toString() {
		return "Department [deptno=" + deptno + ", dname=" + dname + ", loc="
				+ loc + "]";
	}

}
