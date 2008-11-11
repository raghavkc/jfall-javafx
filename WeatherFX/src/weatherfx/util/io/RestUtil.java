/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package weatherfx.util.io;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;

/**
 *
 * @author nl24167
 */
public class RestUtil {

    public static String makeRestCall(String addr, String path, String query) throws IOException {
        URL url = new URL("http://" + addr + path + query);
        URLConnection connection = url.openConnection();
        connection.connect();
        
        InputStream stream = connection.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
        
        String line = reader.readLine();
        StringBuffer result = new StringBuffer();
        while (line != null) {
            result.append(line);
            line = reader.readLine();
        }
        
        return result.toString();
    }
}