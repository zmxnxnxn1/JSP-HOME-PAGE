package study.java.helper;

import java.util.regex.Pattern;

public class RegexHelper {
  //----------- �̱��� ��ü ���� ���� ----------
  private static RegexHelper current = null;

  public static RegexHelper getInstance() {
    if (current == null) {
      current = new RegexHelper();
    }
    return current;
  }

  public static void freeInstance() {
    current = null;
  }

  private RegexHelper() {
    super();
  }

  //----------- �̱��� ��ü ���� �� ----------

  /** �־��� ���ڿ��� �����̰ų� null������ �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ����,null�� �ƴ� ��� true ���� */
  public boolean isValue(String str) {
    boolean result = false;
    if (str != null) {
      result = !str.trim().equals("");
    }
    return result;
  }

  /** ���� ��翡 ���� ���� �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isNum(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^[0-9]*$", str);
    }
    return result;
  }

  /** �������θ� �����Ǿ������� ���� ���� �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isEng(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^[a-zA-Z]*$", str);
    }
    return result;
  }

  /** �ѱ۷θ� �����Ǿ������� ���� ���� �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isKor(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^[��-����-�R]*$", str);
    }
    return result;
  }

  /** ������ ���ڷθ� �����Ǿ������� ���� ���� �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isEngNum(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^[a-zA-Z0-9]*$", str);
    }
    return result;
  }

  /** �ѱ۰� ���ڷθ� �����Ǿ������� ���� ���� �˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isKorNum(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^[��-����-�R0-9]*$", str);
    }
    return result;
  }

  /** �̸��� ���������� ���� �˻�.
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false  */
  public boolean isEmail(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches(
    		  "[0-9a-zA-Z]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$", str);
    }
    return result;
  }

  /** "-"���� �ڵ�����ȣ������ ���� ���İ˻�.
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isCellPhone(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches(
    		  "^01(?:0|1|[6-9])(?:\\d{3}|\\d{4})\\d{4}$", str);
    }
    return result;
  }

  /** "-"���� ��ȭ��ȣ������ ���� ���İ˻�.
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isTel(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^\\d{2,3}\\d{3,4}\\d{4}$", str);
    }
    return result;
  }

  /** "-"���� �ֹι�ȣ�� ���� ���İ˻�
   * @param   str - �˻��� ���ڿ�
   * @return  boolean - ���Ŀ� ���� ��� true, ���� ���� ��� false */
  public boolean isJumin(String str) {
    boolean result = false;
    if (isValue(str)) {
      result = Pattern.matches("^\\d{6}[1-4]\\d{6}", str);
    }
    return result;
  }
}
