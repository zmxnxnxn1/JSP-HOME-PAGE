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
    // request 내장객체의 참조
    private HttpServletRequest request;
    
    // response 내장객체의 참조
    private HttpServletResponse response;

    // ------------ 싱글톤 객체 시작 --------------
    // 싱글톤 객체 
    private static WebHelper current;
    
    // out 내장객체의 참조
    private JspWriter out; // this.out.println() 할때 사용함

    /**
     * 싱글톤 객체를 생성하여 리턴한다.
     * @param request - JSP request 내장객체
     * @return WebHelper
     */
    public static WebHelper getInstance(HttpServletRequest request, HttpServletResponse response, JspWriter out) {
        // 파라미터의 인코딩 방식을 UTF-8로 처리하도록 설정
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        if (current == null) {
            current = new WebHelper();
        }
        
        // 내장객체의 참조 연결 
        current.request = request;
        current.response = response;
        current.out = out;

        return current;
    }

    /**
     * 싱글톤 객체를 삭제한다.
     */
    public static void freeInstance() {
        current = null;
    }

    /**
     * 생성자.
     */
    private WebHelper() {
    }

    // ------------ 싱글톤 객체 끝 --------------

    /**
     * 파라미터를 전달받아서 리턴한다.
     * @param fieldName 	- 파라미터 이름
     * @param defaultValue	- 값이 없을 경우 사용될 기본값
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
     * 파라미터를 전달받아서 리턴한다. 값이 없을 경우 Null을 리턴한다.
     * @param fieldName - 파라미터 이름
     * @return String
     */
    public String getString(String fieldName) {
        return this.getString(fieldName, null);
    }
    // 이 메소드가 실행은 위에있는 getString(String fieldName, String defaultValue) 이것을 실행한다.
    // getString 메소드의 두번째 인자값을 넣지 않았을때, null을 반환하는경우 null을 반환하게끔 한다.
    // getString 메소도의 두번째 인자값을 넣으면 null을 반환하는경우 null 대신 두번째 인자값을 반환하게끔 한다.
    // -> getString(String fieldName) 함수를 실행하면 getString(String fieldName, String defaultValue) 함수가 실행 된다.

    /**
     * 파라미터를 전달받아서 int로 형변환 하여 리턴한다.
     * @param fieldName 	- 파라미터 이름
     * @param defaultValue	- 값이 없을 경우 사용될 기본값
     * @return	int
     */
    public int getInt(String fieldName, int defaultValue) {
        int result = defaultValue;

        String param = this.getString(fieldName); // request 객체는 String값으로 넘어오기 때문에 getString 메소드를 실행하여 값을 만들고 숫자로 변환한다.

        if (param != null) {
            try {
                result = Integer.parseInt(param);
            } catch (NumberFormatException e) {
            }
        }

        return result;
    }
    
    /**
     * 파라미터를 전달받아서 int로 형변환 하여 리턴한다.
     * 값이 없을 경우 0을 리턴한다.
     * @param fieldName     - 파라미터 이름
     * @return  int
     */
    public int getInt(String fieldName) {
        return this.getInt(fieldName, 0);
    }
    
    /**
     * 메시지 표시 후, 페이지를 지정된 곳으로 이동한다.
     * @param url - 이동할 페이지의 URL, Null일 경우 이전페이지로 이동
     * @param msg - 화면에 표시할 메시지. Null일 경우 표시 안함
     */
    public void redirect(String url, String msg) {
        String html = "<!doctype html>";
        html += "<html>";
        html += "<head>";
        html += "<meta charset='utf-8'>";

        // 메시지 표시
        if (msg != null) {
            html += "<script type='text/javascript'>alert('" + msg
                    + "');</script>";
        }

        // 페이지 이동
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
     * 쿠키값을 저장한다.
     * @param key       - 쿠키이름
     * @param value     - 값
     * @param timeout   - 설정시간. 브라우저를 닫으면 즉시 삭제할 경우 -1
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
		
		// 시간값이 0보다 작은 경우는 이 메서드를 설정하지 않도록 한다.
		// --> 브라우저를 닫으면 삭제된다.
		// 0으로 설정할 경우 setMaxAge(0)이라고 설정되므로 즉시 삭제된다.
		if (timeout > -1) {
		    cookie.setMaxAge(timeout);
		}
		
		this.response.addCookie(cookie);
    }

    /**
     * 쿠키값을 조회한다.
     * @param key   - 쿠키이름
     * @param defaultValue  - 값이 없을 경우 사용될 기본값
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
     * 쿠키값을 조회한다. 값이 없을 경우 Null을 리턴한다.
     * @param key   - 쿠키이름
     * @return  String
     */
    public String getCookie(String key) {
        return this.getCookie(key, null);
    }

}
