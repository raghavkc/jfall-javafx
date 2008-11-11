/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package weatherfx.util.geo;

/**
 *
 * @author nl24167
 */
public class LocationInfo {

    private String name;
        private CoordinatePoint coordinate;
        private float longitude;
        private float latitude;
        private String countryCode;
        private String metarCode;
        private String metarString;

    public String getMetarString() {
        return metarString;
    }

    public void setMetarString(String metarString) {
        this.metarString = metarString;
    }

    public String getMetarCode() {
        return metarCode;
    }

    public void setMetarCode(String MetarCode) {
        this.metarCode = MetarCode;
    }

        public LocationInfo(String name, String countryCode) {
            this.name = name;
            this.countryCode = countryCode;
        }

        public String getCountryCode() {
            return countryCode;
        }

        public void setCountryCode(String countryCode) {
            this.countryCode = countryCode;
        }

        public float getLatitude() {
            return latitude;
        }

        public void setLatitude(float latitude) {
            this.latitude = latitude;
        }

        public float getLongitude() {
            return longitude;
        }

        public void setLongitude(float longitude) {
            this.longitude = longitude;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public CoordinatePoint getCoordinate() {
            return coordinate;
        }

        public void setCoordinate(CoordinatePoint coordinate) {
            this.coordinate = coordinate;
        }

        @Override
        public String toString() {
            return name + ":" + countryCode + ":" + longitude + ":" + latitude + " " + coordinate;
        }
}
