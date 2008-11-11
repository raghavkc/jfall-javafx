/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package weatherfx.util.geo;

/**
 *
 * @author nl24167
 */
public class GeoUtil {

        public static CoordinatePoint latLongToCoordinate(double latitude, double longitude) {
        
        latitude = Math.PI * latitude / 180;
        longitude = Math.PI * longitude / 180;
        
        //longitude += 1.570795765134/2;
        double y =  (Math.cos(latitude) * Math.cos(longitude));
        double x =  (Math.cos(latitude) * Math.sin(longitude));
        
        //x = radius_of_world * Math.cos(longitude) * Math.cos(latitude)
        //y = radius_of_world * Math.sin(longitude) * Math.cos(latitude)
        
        CoordinatePoint point = new CoordinatePoint(x,y);        
        
        return point;
    }
}
