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
	/****** ���ε带 �ޱ� ���� ȯ�漳�� ���� ******/
	// �ڽ��� Workspace ���
	private static final String homeDir = "/JAVA/pdfBoardMVC1/WebContent/uploadFile";
	// ���ε� �� ������� ����� ���� 
	private static final String uploadDir = homeDir + "/upload";
	// ���ε尡 ����� �ӽ� ����
	private static final String tempDir = uploadDir + "/temp";
	
	// File������ �����ϱ� ���� �÷���
	// --> import java.util.List
	// --> import java.util.ArrayList
	// --> import study.jsp.uploadex.model.FileInfo
	private List<FileInfo> fileList;
		
	// �� ���� �Ϲ� �����͸� �����ϱ� ���� �÷���
	// --> import java.util.Map
	// --> import java.util.HashMap
	private Map<String, String> paramMap;
	
    // request ���尴ü�� ����
    private HttpServletRequest request;

    // response ���尴ü�� ����
    private HttpServletResponse response;
    
    // out ���尴ü�� ����
    private JspWriter out;

    // ------------ �̱��� ��ü ���� --------------
    // �̱��� ��ü 
    private static WebHelper current;

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

    /**
     * �Ķ���͸� ���޹޾Ƽ� int�� ����ȯ �Ͽ� �����Ѵ�.
     * @param fieldName 	- �Ķ���� �̸�
     * @param defaultValue	- ���� ���� ��� ���� �⺻��
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
    
    /**
     * Multipart�� ���۵� �����͸� ó���Ѵ�.
     * @return boolean (����:true, ����:false)
     */
    public boolean multipartRequest() {
    	boolean result = true;
    	
    	// multipart�� ���۵Ǿ����� ���� �˻�
    	// --> import org.apache.commons.fileupload.servlet.ServletFileUpload
    	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    	
    	if (!isMultipart) {
            // ���۵��� �ʾҴٸ� false����
    		return false;
    	}
    	
    	// ������ ���� ���� üũ�ؼ� �����ϱ� 
    	// import java.io.File
    	File uploadDirFile = new File(uploadDir);
    	if (!uploadDirFile.exists()) {
    		uploadDirFile.mkdirs();
    	}
    	
    	File tempDirFile = new File(tempDir);
    	if (!tempDirFile.exists()) {
    		tempDirFile.mkdirs();
    	}
    	
    	// ���ε尡 ����� �ӽ� ���� ����
    	// --> import org.apache.commons.fileupload.disk.DiskFileItemFactory
    	DiskFileItemFactory factory = new DiskFileItemFactory();
    	factory.setRepository(tempDirFile);
    	
    	
    	/****** ���ε� ���� ******/
    	ServletFileUpload upload = new ServletFileUpload(factory);
    	// UTF-8 ó�� ����
    	upload.setHeaderEncoding("UTF-8");
    	// �ִ� ���� ũ�� --> 10M
    	upload.setSizeMax(10 * 1024 * 1024);
    	// ���� ���ε带 �����Ͽ� ���� �� �Ķ���͵��� ���
    	List<FileItem> items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
            // ������ �߻��ߴٸ� false ����
			return false;
		}
		
        // �����Ͱ� ����� �÷��� �Ҵ��ϱ�
		fileList = new ArrayList<FileInfo>();
		paramMap = new HashMap<String, String>();

    	/********* ���ε� �� ������ ���� ó�� *************/
    	for (int i=0; i<items.size(); i++) {
    		// import org.apache.commons.fileupload.FileItem
    		FileItem f = items.get(i);
    		
    		if (f.isFormField())  {
    			/** ���� ������ �����Ͱ� �ƴ� ��� */
    			String key = f.getFieldName();
    			String value = null;
    			
    			try {
    				// value�� UTF-8 �������� ����Ѵ�.
    				value = f.getString("UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
    			
    			// �̹� ������ Ű���� map�ȿ� �����Ѵٸ�?
    			if (paramMap.containsKey(key)) {
    				// ������ �� �ڿ� �޸�(,)�� �߰��ؼ� ���� �����Ѵ�.
    				String new_value = paramMap.get(key) + "," + value;
    				paramMap.put(key, new_value);
    			} else {
    				// �׷��� �ʴٸ� Ű�� ���� �űԷ� �߰��Ѵ�.
    				paramMap.put(key, value);
    			}
    			
    		} else {
    			/** ���� ������ �������� ��� */
    			// <input type='file' />�� name �Ӽ�
    			String fieldName = f.getFieldName();
    			// ������ ���� �̸�
    			String orginName = f.getName();
    			// ���� ����
    			String contentType = f.getContentType();
    			// ���� ������
    			long fileSize = f.getSize();
    			
    			// ���� ����� ���ٸ� �������� ���ư���.
    			if (fileSize < 1) {
    				continue;
    			}
    			
    			// �����̸����� Ȯ���ڸ� ����
    			String ext = orginName.substring(orginName.lastIndexOf("."));
    			
    			// �� ������ ����� �̸��� ������ Timestamp�� �������� ����ؼ� ���� (�ߺ����� ���)
    			String upload_name = System.currentTimeMillis() 
    								+ "_" 
    								+ Util.getInstance().random(1000, 9999) 
    								+ ext;
    			
    			// ������ �̸��� ������ �����ϴ��� �˻��Ѵ�.
    			boolean isfind = true;
    			while (isfind) {
    				File upload_file = new File(upload_name);
    				
    				if (!upload_file.exists()) {
    					// ������ �̸��� ���ٸ� �ݺ� �ߴ��� ���ؼ� ���ǰ� ����
    					isfind = false;
    				} else {
    					// �׷��� �ʴٸ� �����̸��� ����
    					upload_name = System.currentTimeMillis() 
    									+ "_" 
    									+ Util.getInstance().random(1000, 9999) 
    									+ ext;
    				} // end if~else
    			} // end while
    			
    			// �ӽ� ������ �����ϴ� ������ ������ ������ �����ϰ�, �ӽ����� ����
    			try {
    				File saveFile = new File(uploadDirFile, upload_name);
    				f.write(saveFile);
    				f.delete();
    				
    				// ������ ������ Beans�� ��ü�� �����ؼ� �÷��ǿ� �����Ѵ�.
    				// --> �� ������ ���� ������ ���ε� ������ DB�� ������ �� ���ȴ�.
    				FileInfo info = new FileInfo(fieldName, orginName, uploadDir, 
    						upload_name, contentType, fileSize);
    				fileList.add(info);
    			} catch (IOException ioe) {
    				ioe.printStackTrace();
    			} catch (Exception e) {
					e.printStackTrace();
				} // end try~catch
    			
    			/** ���� ������ �������� ��� �� */
    		} // end if
    	} // end for
    	
    	return result;
    }
    
    /**
     * ���ε�� ������ ����Ʈ�� �����Ѵ�.
     */
    public List<FileInfo> getFileList() {
    	return this.fileList;
    }
    
    /**
     * ���ε�ÿ� �Բ� ���޵� �Ķ���͵��� �÷����� �����Ѵ�.
     */
    public Map<String, String> getParamMap() {
    	return this.paramMap;
    }

    /**
     * ��� �޽����� JSON���� ����Ѵ�.
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
     * ����� �̹����� �����Ͽ� �����Ѵ�.
     * �̹����� ũ��� �ִ� ���� ���̿� ���ؼ� ���������� ����Ѵ�.
     * @param loadFile - ���� ���� ���
     * @param saveFile - ������ ���� ���
     * @param maxDim - �ִ� ���� ���� ����
     * @return
     */
	public boolean createThumbnail(String loadFile, String saveFile, int maxDim) {
		boolean result = false;
		
        /** ������ ���Ͽ� ���� ��ü */
		// import java.io.File;
		File save = new File(saveFile);
		
        /** �̹����� ���� ���� ��ü */
		// import java.io.FileInputStream;
		FileInputStream fis = null;
		// import java.awt.image.BufferedImage;
		BufferedImage im = null;
		
        /** ���� ��ü�� ��� �̹����� ��ȯ�Ѵ� */
		try {
            /** ���� ������ ����. */
			fis = new FileInputStream(loadFile);
            /** ���� ���� ��ü�� �̹��� ��ü�� ��ȯ�Ѵ�. */
			// import javax.imageio.ImageIO;
			im = ImageIO.read(fis);
		} catch (FileNotFoundException e) {
			// import java.io.FileNotFoundException;
			e.printStackTrace();
		} catch (IOException e) {
			// import java.io.IOException;
			e.printStackTrace();
		}
		
        // �̹��� ��ü�� ���ٸ� ó�� ���
		//if (im == null) {
		//	return false;
		//}
		
        /** ���� ��ü�� �̹��� ������ �����Ͽ� ������ �̹��� ũ�⸦ ����Ѵ�. */
		// import java.awt.Image;
		// import javax.swing.ImageIcon;
		Image inImage = new ImageIcon(loadFile).getImage();
		
        // ��û�� �̹��� ũ��� ���� �̹��� ���̰��� ���� ��� 
		double scale = (double) maxDim / (double) inImage.getHeight(null);
		
        // ���� �̹����� ���̰� ���̺��� ũ�ٸ�? �� ���� �ִ�ġ�� ����ϱ� ���ؼ�
        // ���̿� ���� ������ �����Ѵ�.
		if (inImage.getWidth(null) > inImage.getHeight(null)) {
			scale = (double) maxDim / (double) inImage.getWidth(null);
		}
		
        // ����� ������ �̹��� ���� ũ�⿡ �����Ͽ� ��ҵ� ũ�⸦ ��´�.
		int scaledW = (int) (scale * inImage.getWidth(null));
		int scaledH = (int) (scale * inImage.getHeight(null));
		
        /** �̹��� �����ϱ� */
		BufferedImage thumb = new BufferedImage(scaledW, scaledH, BufferedImage.TYPE_INT_RGB);
		
        // ��ҵ� ũ�⸦ ����Ͽ� �� �̹����� �����Ѵ�.
		// import java.awt.Graphics2D;
		Graphics2D g2 = thumb.createGraphics();
		g2.drawImage(im, 0, 0, scaledW, scaledH, null);
		
        // �� �̹����� ���� �̹����� ������ ����Ѵ�.
		try {
			result = ImageIO.write(thumb, "jpg", save);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
