package study.java.helper;

public class PageHelper {
	/***** GET�Ķ���ͷ� ó���� �� *****/
    private int page = 1; 			// ���� ������ ��ȣ

    /***** DB���� ��ȸ�� ��� �� *****/
    private int totalCount = 0;		// ��ü �� ���� ��ȸ

    /***** �����ڰ� �����ؾ� �ϴ� �� *****/
    private int listCount = 10;		// �� �������� ������ ���� ��� ��
    private int groupCount = 5;		// �� �׷쿡 ǥ���� ��������ȣ ����

	/***** ����ó���� �ʿ��� �� *****/
	private int totalPage = 0;		// ��ü ������ ��
    private int startPage = 0;		// ���� �׷��� ���� ������ 
    private int endPage = 0;		// ���� �׷��� ������ ������
    private int prevPage = 0;		// ���� �׷��� ������ ������
    private int nextPage = 0;		// ���� �׷��� ù ������
    private int limitStart = 0;		// MySQL�� Limit ���� ��ġ

	// ----------- �̱��� ��ü ���� ���� ----------
	private static PageHelper current = null;

	public static PageHelper getInstance(int page, int totalCount, 
									int listCount, int groupCount) {
		if (current == null) {
			current = new PageHelper();
		}
		// ��ü ���� ��, ��꿡 �ʿ��� ������ ����ó���� ���� �޼��忡 �����Ѵ�.
		current.pageProcess(page, totalCount, listCount, groupCount);
		return current;
	}

	public static void freeInstance() { current = null; }

	private PageHelper() { super(); }
	// ----------- �̱��� ��ü ���� �� ----------
	
	/** ������ ������ �ʿ��� ������ ó���ϴ� �޼��� */
	private void pageProcess(int page, int totalCount, 
								int listCount, int groupCount) {
		this.page = page;
		this.totalCount = totalCount;
		this.listCount = listCount;
		this.groupCount = groupCount;

		// ��ü ������ ��
	    totalPage = ((totalCount-1)/listCount)+1;

	    // ���� �������� ���� ���� ����
	    if (page < 0) {
	    	page = 1;
	    }
	    
	    if (page > totalPage) {
	    	page = totalPage;
	    }

	    // ���� ����¡ �׷��� ���� ������ ��ȣ
	    startPage = ((page - 1) / groupCount) * groupCount + 1;

	    // ���� ����¡ �׷��� �� ������ ��ȣ
	    endPage = (((startPage - 1) + groupCount) / groupCount) * groupCount;

	    // �� ������ ��ȣ�� ��ü ���������� �ʰ��ϸ� �������� ����
	    if (endPage > totalPage) {
	    	endPage = totalPage;
	    }

	    // ���� �׷��� ������ ������
	    if (startPage > groupCount) {
	        prevPage = startPage - 1;
	    } else {
	    	prevPage = 0;
	    }

	    // ���� �׷��� ù ������
	    if (endPage < totalPage) {
	        nextPage = endPage + 1;
	    } else {
	    	nextPage = 0;
	    }

	    // �˻� ������ ���� ��ġ
	    limitStart = (page-1) * listCount;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getListCount() {
		return listCount;
	}

	public void setListCount(int listCount) {
		this.listCount = listCount;
	}

	public int getGroupCount() {
		return groupCount;
	}

	public void setGroupCount(int groupCount) {
		this.groupCount = groupCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getPrevPage() {
		return prevPage;
	}

	public void setPrevPage(int prevPage) {
		this.prevPage = prevPage;
	}

	public int getNextPage() {
		return nextPage;
	}

	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}

	public int getLimitStart() {
		return limitStart;
	}

	public void setLimitStart(int limitStart) {
		this.limitStart = limitStart;
	}

	@Override
	public String toString() {
		return "PageHelper [page=" + page + ", totalCount=" + totalCount
				+ ", listCount=" + listCount + ", groupCount=" + groupCount
				+ ", totalPage=" + totalPage + ", startPage=" + startPage
				+ ", endPage=" + endPage + ", prevPage=" + prevPage
				+ ", nextPage=" + nextPage + ", limitStart=" + limitStart + "]";
	}
}
