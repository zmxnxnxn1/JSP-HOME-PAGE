package study.jsp.simplemvc.model;

/** department ���̺� ������ ���� Java Beans ���� */
public class Department {
	private int deptno;
	private String dname;
	private String loc;
	
	// �˻���
	private String keyword;
	
	// ������ ������ ���� LIMIT ���� ��ġ
	int limitStart;
	
	// �� �������� ������ ��� ��
	int listCount;

	/** �⺻ ������ */
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
