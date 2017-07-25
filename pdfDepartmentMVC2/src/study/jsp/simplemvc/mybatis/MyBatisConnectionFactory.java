package study.jsp.simplemvc.mybatis;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisConnectionFactory {
	/** �����ͺ��̽� ���� ��ü */
	private static SqlSessionFactory sqlSessionFactory;
	
	/** XML�� ��õ� ���� ������ �о���δ�. */
	static {
		try	{
			// ���� ������ ����ϰ� �ִ� XML�� ��� �б�
			Reader reader = Resources.getResourceAsReader("study/jsp/simplemvc/mybatis/config.xml");
			
			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
			}
		} catch (FileNotFoundException fileNotFoundException) {
			fileNotFoundException.printStackTrace();
		} catch (IOException ioException) {
			ioException.printStackTrace();
		}
	}
	
	/** �����ͺ��̽� ���� ��ü�� �����Ѵ�. */
	public static SqlSessionFactory getSqlSessionFactory() {
		return sqlSessionFactory;
	}
}
