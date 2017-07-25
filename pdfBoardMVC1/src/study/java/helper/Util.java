package study.java.helper;

/**
 * �⺻���� ���� ��ɵ��� ���� ���� Ŭ����
 */
public class Util {
	// ----------- �̱��� ��ü ���� ���� -----------
	private static Util current = null;
	
	public static Util getInstance() {
		if (current == null) {
			current = new Util();
		}
		return current;
	}
	
	public static void freeInstance() {
		current = null;
	}
	
	private Util() {
		super();
	}
	// ----------- �̱��� ��ü ���� �� -----------
	
	/**
	 * ������ ���� �������� �����Ͽ� �����ϴ� �޼���
	 * @param min - ���� �ȿ����� �ּҰ�
	 * @param max - ���� �ȿ����� �ִ밪
	 * @return min~max �ȿ����� ������
	 */
	public int random(int min, int max) {
		int num = (int) ((Math.random() * (max - min + 1)) + min);
		return num;
	}
}
