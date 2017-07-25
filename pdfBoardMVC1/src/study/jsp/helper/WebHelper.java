package study.jsp.helper;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;

public class WebHelper {
    // request ���尴ü�� ����
    private HttpServletRequest request;
    
    // response ���尴ü�� ����
    private HttpServletResponse response;

    // ------------ �̱��� ��ü ���� --------------
    // �̱��� ��ü 
    private static WebHelper current;
    
    // out ���尴ü�� ����
    private JspWriter out; // this.out.println() �Ҷ� �����

    /**
     * �̱��� ��ü�� �����Ͽ� �����Ѵ�.
     * @param request - JSP request ���尴ü
     * @return WebHelper
     */
    public static WebHelper getInstance(HttpServletRequest request, HttpServletResponse response, JspWriter out) {
        // �Ķ������ ���ڵ� ����� UTF-8�� ó���ϵ��� ����
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        if (current == null) {
            current = new WebHelper();
        }
        
        // ���尴ü�� ���� ���� 
        current.request = request;
        current.response = response;
        current.out = out;

        return current;
    }

    /**
     * �̱��� ��ü�� �����Ѵ�.
     */
    public static void freeInstance() {
        current = null;
    }

    /**
     * ������.
     */
    private WebHelper() {
    }

    // ------------ �̱��� ��ü �� --------------

    /**
     * �Ķ���͸� ���޹޾Ƽ� �����Ѵ�.
     * @param fieldName 	- �Ķ���� �̸�
     * @param defaultValue	- ���� ���� ��� ���� �⺻��
     * @return String
     */
    public String getString(String fieldName, String defaultValue) {
        String result = defaultValue;
        String param = this.request.getParameter(fieldName);

        if (param != null) {
            param = param.trim();

            if (!param.equals("")) {
                result = param;
            }
        }

        return result;
    }

    /**
     * �Ķ���͸� ���޹޾Ƽ� �����Ѵ�. ���� ���� ��� Null�� �����Ѵ�.
     * @param fieldName - �Ķ���� �̸�
     * @return String
     */
    public String getString(String fieldName) {
        return this.getString(fieldName, null);
    }
    // �� �޼ҵ尡 ������ �����ִ� getString(String fieldName, String defaultValue) �̰��� �����Ѵ�.
    // getString �޼ҵ��� �ι�° ���ڰ��� ���� �ʾ�����, null�� ��ȯ�ϴ°�� null�� ��ȯ�ϰԲ� �Ѵ�.
    // getString �޼ҵ��� �ι�° ���ڰ��� ������ null�� ��ȯ�ϴ°�� null ��� �ι�° ���ڰ��� ��ȯ�ϰԲ� �Ѵ�.
    // -> getString(String fieldName) �Լ��� �����ϸ� getString(String fieldName, String defaultValue) �Լ��� ���� �ȴ�.

    /**
     * �Ķ���͸� ���޹޾Ƽ� int�� ����ȯ �Ͽ� �����Ѵ�.
     * @param fieldName 	- �Ķ���� �̸�
     * @param defaultValue	- ���� ���� ��� ���� �⺻��
     * @return	int
     */
    public int getInt(String fieldName, int defaultValue) {
        int result = defaultValue;

        String param = this.getString(fieldName); // request ��ü�� String������ �Ѿ���� ������ getString �޼ҵ带 �����Ͽ� ���� ����� ���ڷ� ��ȯ�Ѵ�.

        if (param != null) {
            try {
                result = Integer.parseInt(param);
            } catch (NumberFormatException e) {
            }
        }

        return result;
    }
    
    /**
     * �Ķ���͸� ���޹޾Ƽ� int�� ����ȯ �Ͽ� �����Ѵ�.
     * ���� ���� ��� 0�� �����Ѵ�.
     * @param fieldName     - �Ķ���� �̸�
     * @return  int
     */
    public int getInt(String fieldName) {
        return this.getInt(fieldName, 0);
    }
    
    /**
     * �޽��� ǥ�� ��, �������� ������ ������ �̵��Ѵ�.
     * @param url - �̵��� �������� URL, Null�� ��� ������������ �̵�
     * @param msg - ȭ�鿡 ǥ���� �޽���. Null�� ��� ǥ�� ����
     */
    public void redirect(String url, String msg) {
        String html = "<!doctype html>";
        html += "<html>";
        html += "<head>";
        html += "<meta charset='utf-8'>";

        // �޽��� ǥ��
        if (msg != null) {
            html += "<script type='text/javascript'>alert('" + msg
                    + "');</script>";
        }

        // ������ �̵�
        if (url != null) {
            html += "<meta http-equiv='refresh' content='0; url=" 
                    + url + "' />";
        } else {
            html += "<script type='text/javascript'>";
            html += "history.back();";
            html += "</script>";
        }

        html += "</head>";
        html += "<body></body>";
        html += "</html>";

        try {
            this.out.println(html);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    
    /**
     * ��Ű���� �����Ѵ�.
     * @param key       - ��Ű�̸�
     * @param value     - ��
     * @param timeout   - �����ð�. �������� ������ ��� ������ ��� -1
     */
    public void setCookie(String key, String value, int timeout) {
		try {
			// import java.net.URLEncoder
		    value = URLEncoder.encode(value, "UTF-8");
		} catch (UnsupportedEncodingException e) {
		    e.printStackTrace();
		}
		
		Cookie cookie = new Cookie(key, value);
		cookie.setPath("/");
		
		// �ð����� 0���� ���� ���� �� �޼��带 �������� �ʵ��� �Ѵ�.
		// --> �������� ������ �����ȴ�.
		// 0���� ������ ��� setMaxAge(0)�̶�� �����ǹǷ� ��� �����ȴ�.
		if (timeout > -1) {
		    cookie.setMaxAge(timeout);
		}
		
		this.response.addCookie(cookie);
    }

    /**
     * ��Ű���� ��ȸ�Ѵ�.
     * @param key   - ��Ű�̸�
     * @param defaultValue  - ���� ���� ��� ���� �⺻��
     * @return  String
     */
    public String getCookie(String key, String defaultValue) {
        String result = defaultValue;
        // import javax.servlet.http.Cookie
        Cookie[] cookies = this.request.getCookies();

        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                String cookieName = cookies[i].getName();
                
                if (cookieName.equals(key)) {
                    result = cookies[i].getValue();
                    try {
                    	// import java.net.URLDecoder
                        result = URLDecoder.decode(result, "UTF-8");
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        return result;
    }

    /**
     * ��Ű���� ��ȸ�Ѵ�. ���� ���� ��� Null�� �����Ѵ�.
     * @param key   - ��Ű�̸�
     * @return  String
     */
    public String getCookie(String key) {
        return this.getCookie(key, null);
    }

}
