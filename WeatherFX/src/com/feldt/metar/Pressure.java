/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feldt.metar;

/**
 *
 * @author nl24167
 */
public class Pressure {
    
    private int pressure;

    public static boolean isAPressure(String metarString) {
        if (metarString.startsWith("Q")) {
            return true;
        } else {
            return false;
        }
    }

    static Pressure parsePressure(String token) {
       Pressure p = new Pressure();
       p.pressure = Integer.parseInt(token.substring(1));
       
       return p;
    }
    
    public String toString() {
        return pressure + "";
    }
}
