package config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Centralized application configuration reader.
 * Reads key-value pairs from WEB-INF/cloudinary.properties.
 *
 * Usage: AppConfig.get("cloudinary.api_key");
 */
public class AppConfig {

    private static final Properties props = new Properties();
    private static boolean loaded = false;

    /**
     * Loads properties from WEB-INF/cloudinary.properties using the classloader.
     * The file is located relative to the classpath root.
     * In a typical Tomcat deployment, WEB-INF/classes is on the classpath,
     * but WEB-INF/ itself is not. So we use a relative path trick:
     * we load from the classpath by navigating to the parent WEB-INF folder.
     */
    private static synchronized void loadProperties() {
        if (loaded) return;

        // Try loading from classpath (works when file is copied to WEB-INF/)
        // In Tomcat, the webapp resource can be accessed via classloader
        // by using "../cloudinary.properties" relative to WEB-INF/classes/
        InputStream is = AppConfig.class.getClassLoader()
                .getResourceAsStream("../cloudinary.properties");

        if (is == null) {
            // Fallback: try loading from the same classloader root
            is = AppConfig.class.getClassLoader()
                    .getResourceAsStream("cloudinary.properties");
        }

        if (is == null) {
            System.err.println("[AppConfig] FATAL: cloudinary.properties not found!");
            System.err.println("[AppConfig] Expected location: WEB-INF/cloudinary.properties");
            loaded = true;
            return;
        }

        try {
            props.load(is);
            System.out.println("[AppConfig] cloudinary.properties loaded successfully.");
        } catch (IOException e) {
            System.err.println("[AppConfig] Error reading cloudinary.properties: " + e.getMessage());
        } finally {
            try { is.close(); } catch (IOException ignored) {}
        }

        loaded = true;
    }

    /**
     * Returns the value for the given configuration key.
     * @param key The property key (e.g., "cloudinary.cloud_name")
     * @return The property value, or null if not found
     */
    public static String get(String key) {
        loadProperties();
        return props.getProperty(key);
    }

    /**
     * Returns the value for the given configuration key, or a default value if not found.
     * @param key The property key
     * @param defaultValue Fallback value
     * @return The property value, or defaultValue if not found
     */
    public static String get(String key, String defaultValue) {
        loadProperties();
        return props.getProperty(key, defaultValue);
    }
}
