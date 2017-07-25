package study.java.helper;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.swing.ImageIcon;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONObject;

public class WebHelper {
	/****** 업로드를 받기 위한 환경설정 시작 ******/
	// 자신의 Workspace 경로
	private static final String homeDir = "/JAVA/pdfBoardMVC1/WebContent/uploadFile";
	// 업로드 된 결과물이 저장될 폴더 
	private static final String uploadDir = homeDir + "/upload";
	// 업로드가 진행될 임시 폴더
	private static final String tempDir = uploadDir + "/temp";
	
	// File정보를 저장하기 위한 컬렉션
	// --> import java.util.List
	// --> import java.util.ArrayList
	// --> import study.jsp.uploadex.model.FileInfo
	private List<FileInfo> fileList;
		
	// 그 밖의 일반 데이터를 저장하기 위한 컬렉션
	// --> import java.util.Map
	// --> import java.util.HashMap
	private Map<String, String> paramMap;
	
    // request 내장객체의 참조
    private HttpServletRequest request;

    // response 내장객체의 참조
    private HttpServletResponse response;
    
    // out 내장객체의 참조
    private JspWriter out;

    // ------------ 싱글톤 객체 시작 --------------
    // 싱글톤 객체 
    private static WebHelper current;

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

    /**
     * 파라미터를 전달받아서 int로 형변환 하여 리턴한다.
     * @param fieldName 	- 파라미터 이름
     * @param defaultValue	- 값이 없을 경우 사용될 기본값
     * @return	int
     */
    public int getInt(String fieldName, int defaultValue) {
        int result = defaultValue;

        String param = this.getString(fieldName);

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
    
    /**
     * Multipart로 전송된 데이터를 처리한다.
     * @return boolean (성공:true, 실패:false)
     */
    public boolean multipartRequest() {
    	boolean result = true;
    	
    	// multipart로 전송되었는지 여부 검사
    	// --> import org.apache.commons.fileupload.servlet.ServletFileUpload
    	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    	
    	if (!isMultipart) {
            // 전송되지 않았다면 false리턴
    		return false;
    	}
    	
    	// 폴더의 존재 여부 체크해서 생성하기 
    	// import java.io.File
    	File uploadDirFile = new File(uploadDir);
    	if (!uploadDirFile.exists()) {
    		uploadDirFile.mkdirs();
    	}
    	
    	File tempDirFile = new File(tempDir);
    	if (!tempDirFile.exists()) {
    		tempDirFile.mkdirs();
    	}
    	
    	// 업로드가 수행될 임시 폴더 연결
    	// --> import org.apache.commons.fileupload.disk.DiskFileItemFactory
    	DiskFileItemFactory factory = new DiskFileItemFactory();
    	factory.setRepository(tempDirFile);
    	
    	
    	/****** 업로드 시작 ******/
    	ServletFileUpload upload = new ServletFileUpload(factory);
    	// UTF-8 처리 지정
    	upload.setHeaderEncoding("UTF-8");
    	// 최대 파일 크기 --> 10M
    	upload.setSizeMax(10 * 1024 * 1024);
    	// 실제 업로드를 수행하여 파일 및 파라미터들을 얻기
    	List<FileItem> items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
            // 에러가 발생했다면 false 리턴
			return false;
		}
		
        // 데이터가 저장될 컬렉션 할당하기
		fileList = new ArrayList<FileInfo>();
		paramMap = new HashMap<String, String>();

    	/********* 업로드 된 파일의 정보 처리 *************/
    	for (int i=0; i<items.size(); i++) {
    		// import org.apache.commons.fileupload.FileItem
    		FileItem f = items.get(i);
    		
    		if (f.isFormField())  {
    			/** 파일 형식의 데이터가 아닌 경우 */
    			String key = f.getFieldName();
    			String value = null;
    			
    			try {
    				// value를 UTF-8 형식으로 취득한다.
    				value = f.getString("UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
    			
    			// 이미 동일한 키값이 map안에 존재한다면?
    			if (paramMap.containsKey(key)) {
    				// 기존의 값 뒤에 콤마(,)를 추가해서 값을 병합한다.
    				String new_value = paramMap.get(key) + "," + value;
    				paramMap.put(key, new_value);
    			} else {
    				// 그렇지 않다면 키와 값을 신규로 추가한다.
    				paramMap.put(key, value);
    			}
    			
    		} else {
    			/** 파일 형식의 데이터인 경우 */
    			// <input type='file' />의 name 속성
    			String fieldName = f.getFieldName();
    			// 파일의 원본 이름
    			String orginName = f.getName();
    			// 파일 형식
    			String contentType = f.getContentType();
    			// 파일 사이즈
    			long fileSize = f.getSize();
    			
    			// 파일 사이즈가 없다면 조건으로 돌아간다.
    			if (fileSize < 1) {
    				continue;
    			}
    			
    			// 파일이름에서 확장자만 추출
    			String ext = orginName.substring(orginName.lastIndexOf("."));
    			
    			// 웹 서버에 저장될 이름을 현재의 Timestamp와 랜덤값을 사용해서 지정 (중복저장 우려)
    			String upload_name = System.currentTimeMillis() 
    								+ "_" 
    								+ Util.getInstance().random(1000, 9999) 
    								+ ext;
    			
    			// 동일한 이름의 파일이 존재하는지 검사한다.
    			boolean isfind = true;
    			while (isfind) {
    				File upload_file = new File(upload_name);
    				
    				if (!upload_file.exists()) {
    					// 동일한 이름이 없다면 반복 중단을 위해서 조건값 변경
    					isfind = false;
    				} else {
    					// 그렇지 않다면 파일이름만 변경
    					upload_name = System.currentTimeMillis() 
    									+ "_" 
    									+ Util.getInstance().random(1000, 9999) 
    									+ ext;
    				} // end if~else
    			} // end while
    			
    			// 임시 폴더에 존재하는 파일을 보관용 폴더에 복사하고, 임시파일 삭제
    			try {
    				File saveFile = new File(uploadDirFile, upload_name);
    				f.write(saveFile);
    				f.delete();
    				
    				// 생성된 정보를 Beans의 객체로 설정해서 컬렉션에 저장한다.
    				// --> 이 정보는 추후 파일의 업로드 내역을 DB에 저장할 때 사용된다.
    				FileInfo info = new FileInfo(fieldName, orginName, uploadDir, 
    						upload_name, contentType, fileSize);
    				fileList.add(info);
    			} catch (IOException ioe) {
    				ioe.printStackTrace();
    			} catch (Exception e) {
					e.printStackTrace();
				} // end try~catch
    			
    			/** 파일 형식의 데이터인 경우 끝 */
    		} // end if
    	} // end for
    	
    	return result;
    }
    
    /**
     * 업로드된 파일의 리스트를 리턴한다.
     */
    public List<FileInfo> getFileList() {
    	return this.fileList;
    }
    
    /**
     * 업로드시에 함께 전달된 파라미터들의 컬렉션을 리턴한다.
     */
    public Map<String, String> getParamMap() {
    	return this.paramMap;
    }

    /**
     * 결과 메시지를 JSON으로 출력한다.
     */
    public void printJsonRt(String rtmsg) {
        // --> import org.json.JSONObject
    	JSONObject json = new JSONObject();
    	json.put("rt", rtmsg);
    	
    	try {
			this.out.print(json.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    
    /**
     * 썸네일 이미지를 생성하여 저장한다.
     * 이미지의 크기는 최대 가로 넓이에 의해서 비율적으로 계산한다.
     * @param loadFile - 원본 파일 경로
     * @param saveFile - 생성될 파일 경로
     * @param maxDim - 최대 가로 넓이 지정
     * @return
     */
	public boolean createThumbnail(String loadFile, String saveFile, int maxDim) {
		boolean result = false;
		
        /** 생성될 파일에 대한 객체 */
		// import java.io.File;
		File save = new File(saveFile);
		
        /** 이미지를 열기 위한 객체 */
		// import java.io.FileInputStream;
		FileInputStream fis = null;
		// import java.awt.image.BufferedImage;
		BufferedImage im = null;
		
        /** 원본 객체를 열어서 이미지로 변환한다 */
		try {
            /** 원본 파일을 연다. */
			fis = new FileInputStream(loadFile);
            /** 원본 파일 객체를 이미지 객체로 변환한다. */
			// import javax.imageio.ImageIO;
			im = ImageIO.read(fis);
		} catch (FileNotFoundException e) {
			// import java.io.FileNotFoundException;
			e.printStackTrace();
		} catch (IOException e) {
			// import java.io.IOException;
			e.printStackTrace();
		}
		
        // 이미지 객체가 없다면 처리 취소
		//if (im == null) {
		//	return false;
		//}
		
        /** 원본 객체의 이미지 정보를 추출하여 생성할 이미지 크기를 계산한다. */
		// import java.awt.Image;
		// import javax.swing.ImageIcon;
		Image inImage = new ImageIcon(loadFile).getImage();
		
        // 요청된 이미지 크기와 원본 이미지 높이간의 비율 얻기 
		double scale = (double) maxDim / (double) inImage.getHeight(null);
		
        // 원본 이미지의 넓이가 높이보다 크다면? 긴 축을 최대치로 사용하기 위해서
        // 넓이에 대한 비율로 변경한다.
		if (inImage.getWidth(null) > inImage.getHeight(null)) {
			scale = (double) maxDim / (double) inImage.getWidth(null);
		}
		
        // 얻어진 비율을 이미지 원본 크기에 복사하여 축소된 크기를 얻는다.
		int scaledW = (int) (scale * inImage.getWidth(null));
		int scaledH = (int) (scale * inImage.getHeight(null));
		
        /** 이미지 생성하기 */
		BufferedImage thumb = new BufferedImage(scaledW, scaledH, BufferedImage.TYPE_INT_RGB);
		
        // 축소된 크기를 사용하여 빈 이미지를 생성한다.
		// import java.awt.Graphics2D;
		Graphics2D g2 = thumb.createGraphics();
		g2.drawImage(im, 0, 0, scaledW, scaledH, null);
		
        // 빈 이미지에 원본 이미지의 내용을 기록한다.
		try {
			result = ImageIO.write(thumb, "jpg", save);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
