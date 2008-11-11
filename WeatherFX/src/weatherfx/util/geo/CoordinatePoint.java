/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package weatherfx.util.geo;

/**
 *
 * @author nl24167
 */
public class CoordinatePoint {

      private double x = 0d;
        private double y = 0d;

        public CoordinatePoint(double x, double y) {
            this.x = x;
            this.y = y;
        }

        public double getX() {
            return x;
        }

        public void setX(double x) {
            this.x = x;
        }

        public double getY() {
            return y;
        }

        public void setY(double y) {
            this.y = y;
        }

        
        @Override
        public String toString() {
            return "CoordinatePoint: " + " x=" + x + " y="  + y;
        }
}
