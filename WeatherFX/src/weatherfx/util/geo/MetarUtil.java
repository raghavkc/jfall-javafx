/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package weatherfx.util.geo;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import net.sf.json.JSONObject;
import weatherfx.util.io.RestUtil;

/**
 *
 * @author nl24167
 */
public class MetarUtil {
    
    private final static String ADDRESS = "ws.geonames.org";
    private final static String PATH = "/weatherIcaoJSON?";
    
   public static List<LocationInfo> processMetarLocations(InputStream ioStream) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(ioStream));
        String line = reader.readLine();
        
        List<LocationInfo> result = new ArrayList<LocationInfo>();
        
        while (line != null) {
            // check whether line doesn't start with !, and contains aa and then a space
            if (!line.startsWith("!")) {
                if (line.length() > 60 && !line.contains("STATION")) {
                    String name = line.substring(2,19);
                    String metarcode = line.substring(20,24);
                    String latitude = line.substring(38,45).trim();
                    String longitude = line.substring(47,54).trim();
                    String cc = line.substring(81,83);
                    
                    LocationInfo info = new LocationInfo(name.trim(),cc);
                    info.setLatitude(convertStringNotationToFloat(latitude));
                    info.setLongitude(convertStringNotationToFloat(longitude));
                    info.setCoordinate(GeoUtil.latLongToCoordinate(info.getLatitude(), info.getLongitude()));
                    info.setMetarCode(metarcode);
                   // info.setMetarString(getMetarString(metarcode));
                    result.add(info);
                }
            }
            line = reader.readLine();
        }
        
        return result;
    }
   
    
    private static float convertStringNotationToFloat(String longLatLocation) {
        String convertedValue = "0.0";
        if (longLatLocation.endsWith("N")) {
            convertedValue = longLatLocation.replace(" ", ".").substring(0, longLatLocation.length()-1);
        } else if (longLatLocation.endsWith("E")) {
            convertedValue = longLatLocation.replace(" ", ".").substring(0, longLatLocation.length()-1);
        } else if (longLatLocation.endsWith("S")) {
            convertedValue = "-" + longLatLocation.replace(" ", ".").substring(0, longLatLocation.length()-1);
        } else if (longLatLocation.endsWith("W")) {
            convertedValue = "-" + longLatLocation.replace(" ", ".").substring(0, longLatLocation.length()-1);
        }
        
        
        return Float.parseFloat(convertedValue);
    }    
    
    private static String getMetarString(String metarCode) throws IOException {
        String result = "";
        String query = "ICAO=" + metarCode;
        String queryResult = RestUtil.makeRestCall(ADDRESS, PATH, query);
        
        if (!queryResult.contains("no observation found")) {
            JSONObject jsonObject = JSONObject.fromObject( queryResult );
            result = jsonObject.getJSONObject("weatherObservation").getString("observation");
        } else {
            result = null;
        }
        
        return result;
    }
    
}
