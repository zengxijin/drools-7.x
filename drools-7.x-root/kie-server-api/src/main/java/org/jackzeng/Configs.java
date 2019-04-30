package org.jackzeng;

import com.google.common.io.Resources;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author xijin.zeng created on 2019/4/30
 */
public class Configs {

    private final static Properties PROPERTIES = new Properties();

    static {
        InputStream input = null;
        try {
            input = Resources.getResource("kie-config.properties").openStream();
            PROPERTIES.load(input);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static String getValue(String key) {
        return PROPERTIES.getProperty(key);
    }

    public static String getKieUrl() {
        return getValue("kie.url");
    }
    public static String getKieUser() {
        return getValue("kie.user");
    }
    public static String getKiePwd() {
        return getValue("kie.password");
    }

}
