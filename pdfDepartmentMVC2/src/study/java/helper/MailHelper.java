package study.java.helper;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailHelper {
	// ----------- �̱��� ��ü ���� ���� ----------
	private static MailHelper current = null;

	public static MailHelper getInstance() {
		if (current == null) {
			current = new MailHelper();
		}
		return current;
	}

	public static void freeInstance() {
		current = null;
	}

	private MailHelper() {
		super();
	}

	// ----------- �̱��� ��ü ���� �� ----------

	/**
	 * ���� ������ ���� ���� ������ ������ �ֱ� ���� Ŭ����
	 * �� �ȿ����� ���Ǵ� Ŭ���� �̹Ƿ� Inner Class�� �����Ѵ�.
	 */
	// import javax.mail.Authenticator
	public class SMTPAuthenticator extends Authenticator {
		/** ���� �߼۽� ���� ������ ������ �ִ� ������ �Ѵ�. */
		// import javax.mail.PasswordAuthentication;
		@Override
		public PasswordAuthentication getPasswordAuthentication() {
			// ���̹��� ��� �ڽ��� ���̵�� ��й�ȣ �Է�
			// Gmail�� ��� �ڽ��� ���� �ּҿ� ��й�ȣ �Է�.
			return new PasswordAuthentication("zmxnxnxn1", "password");
		}
	}
	

	/**
	 * ������ �߼��Ѵ�.
	 * @param sender		- �߼��� ���� �ּ�
	 * @param receiver		- ������ ���� �ּ�
	 * @param subject		- ����
	 * @param content		- ����
	 * @return boolean (����=TRUE, ����=FALSE)
	 */
	public boolean sendMail(String sender, String receiver, String subject, String content) {
		// ���� ���� ���θ� ������ ���� (�ϴ� ���з� ������)
		boolean result = false;

		/** 13-SendMailEx ������ SendMail.jsp �� �ҽ��ڵ� ���� ���� */
		// �߼� ������ ��� ���� ��ü
		Properties p = new Properties();

		// Naver�� ������ ��� ���̹� ���̵�� ���� ����
		// Google�� ������ ��� ������ Gmail �ּҷ� ���� ����
		p.put("mail.smtp.user", "zmxnxnxn1");

		// ���̹��� ��� SMTP ���� ���� ���� 
		//p.put("mail.smtp.host", "smtp.naver.com");
		//p.put("mail.smtp.port", "995");
		// Google�� ��� SMTP ���� ���� ���� 
		p.put("mail.smtp.host", "smtp.naver.com");
		p.put("mail.smtp.port", "465");
		    
		// �Ʒ� ������ ���̹��� ������ �����ϹǷ� �������� ������.
		p.put("mail.smtp.starttls.enable", "true");
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.debug", "true");
		p.put("mail.smtp.socketFactory.port", "465");
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		p.put("mail.smtp.socketFactory.fallback", "false");
		
		/****** ������ ������ ���� ���� �߼� ó�� *****/
		try {
			
			// helper ��Ű���� �غ��� �������� ���� ����� ���� Ŭ������ ��ü ����
		    Authenticator auth = new SMTPAuthenticator();
			
			// �߼ۼ����� ���� ���������� ���������� ����Ͽ�
			// ���� ���� ���� ��ü ����
		    Session ses = Session.getInstance(p, auth);

		    // ������ ������ �� ���� ��Ȳ�� �ֿܼ� ����Ѵ�.
		    ses.setDebug(true);
		        
		    // ������ ������ ��� ���� ��ü
		    MimeMessage msg = new MimeMessage(ses);

		    // ���� ����
		    msg.setSubject(subject);
		        
		    // ������ ����� �����ּ�
		    Address fromAddr = new InternetAddress(sender);
		    msg.setFrom(fromAddr);
		        
		    // �޴� ����� �����ּ�
		    Address toAddr = new InternetAddress(receiver);
		    msg.addRecipient(Message.RecipientType.TO, toAddr);
		        
		    // �޽��� ������ ����� ����, ĳ���� �� ����
		    msg.setContent(content, "text/html;charset=UTF-8");
		        
		    // �߼��ϱ�
		    Transport.send(msg);

			// try ������ �����ٴ� ���� �߼� �����̶�� �ǹ�
			// --> ó�� ��� ���� �����Ѵ�
			result = true;

		} catch (Exception e) {
			System.out.println("���� �߻� ����!");
			e.printStackTrace();
		}
		/** 13-SendMailEx ������ SendMail.jsp �� �ҽ��ڵ� ���� �� */

		return result;
	}
}
