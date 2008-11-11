/*
 * Copyright (c) 2001 Matthew Feldt. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided the copyright notice above is
 * retained.
 *
 * THIS SOFTWARE IS PROVIDED ''AS IS'' AND WITHOUT ANY EXPRESSED OR
 * IMPLIED WARRANTIES.
 */

/**
 * Wind.java
 * 
 * class representing METAR wind information
 * 
 * Wind: 3 digit true-north direction,
 * nearest 10 degrees (or VaRiaBle);
 * next 2-3 digits for speed and unit,
 * KT (KMH or MPS); as needed,
 * Gust and maximum speed; 00000KT for calm;
 * for METAR, if direction varies
 * 60 degrees or more, Variability appended,
 * e.g. 180V260
 * 
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/21/2005
 */

package com.feldt.metar;

import com.feldt.metar.tools.Convert;


public class Wind {
	
	private Integer direction;
	private Integer gust;
	private Integer speed;
	private Integer variesFrom;
	private Integer variesTo;

	private Wind() {
	}

	private String directionLookup(int degrees) {
		if (degrees == 0)
			return "Calm";
		else if (degrees >= 1 && degrees <= 10)
			return "N";
		else if (degrees >= 11 && degrees <= 34)
			return "NNE";
		else if (degrees >= 35 && degrees <= 55)
			return "NE";
		else if (degrees >= 56 && degrees <= 79)
			return "ENE";
		else if (degrees >= 80 && degrees <= 100)
			return "E";
		else if (degrees >= 101 && degrees <= 124)
			return "ESE";
		else if (degrees >= 125 && degrees <= 145)
			return "SE";
		else if (degrees >= 146 && degrees <= 169)
			return "SSE";
		else if (degrees >= 170 && degrees <= 190)
			return "S";
		else if (degrees >= 191 && degrees <= 214)
			return "SSW";
		else if (degrees >= 215 && degrees <= 235)
			return "SW";
		else if (degrees >= 236 && degrees <= 259)
			return "WSW";
		else if (degrees >= 260 && degrees <= 280)
			return "W";
		else if (degrees >= 281 && degrees <= 304)
			return "WNW";
		else if (degrees >= 305 && degrees <= 325)
			return "NW";
		else if (degrees >= 326 && degrees <= 349)
			return "NNW";
		else if (degrees >= 350 && degrees <= 360)
			return "N";
		else if (degrees == -1)
			return "Variable";
		else
			return "Unknown";
	}

	public static boolean isAWind(String metarString) {
		
		if (metarString == null) {
			return false;
		}
		
		char[] buf = metarString.toCharArray();
		boolean isVar = false;
		int i, j;

		// minimum valid string length
		if (buf.length < 7)
			return false;

		// Wind: 3 digit true-north direction,
		// nearest 10 degrees (or VaRiaBle);
		if (buf[0] == 'V') {
			if ((buf[1] != 'R') || (buf[2] != 'B')) {
				return false;
			}
		} else if ((!Character.isDigit(buf[0])) || (!Character.isDigit(buf[1]))
				|| (!Character.isDigit(buf[2]))) {
			return false;
		}

		// next 2-3 digits for speed
		if ((!Character.isDigit(buf[3])) || (!Character.isDigit(buf[4])))
			return false;

		i = 5;
		if (Character.isDigit(buf[i]))
			i++;

		if (buf[i] == 'G') {
			for (j = 1; Character.isDigit(buf[i + j]) && (i + j) < buf.length; j++)
				;
			if (j == 3 || j == 4)
				i += j;
			else
				return false;
		}

		if ((i + 2) != buf.length)
			return false;

		if (buf[i] == 'K' && buf[i + 1] != 'T')
			return false;

		return true;
	}
	
	public static Wind parseWind(String metarString) {
		Wind wind = new Wind();
		char[] buf = metarString.toCharArray();
		int i, j;

		if (buf[0] == 'V') {
			wind.direction = new Integer(-1);
		} else {
			wind.direction = new Integer(Convert.bytesToInt(buf, 0, 3));
		}

		for (i = 3; Convert.isDigit(buf[i]); i++)
			;
		wind.speed = new Integer(Convert.bytesToInt(buf, 3, i));

		if (buf[i] == 'G') {
			i++;
			for (j = i; Convert.isDigit(buf[j]); j++)
				;
			wind.gust = new Integer(Convert.bytesToInt(buf, i, j));
		}
		
		return wind;
	}

	public static boolean isVariable(String in) {
		char[] buf = in.toCharArray();
		int i;

		if (buf.length != 7)
			return false;
		for (i = 0; i < 3; i++)
			if (!Character.isDigit(buf[i]))
				return false;
		if (buf[3] != 'V')
			return false;
		for (i = 4; i < 7; i++)
			if (!Character.isDigit(buf[i]))
				return false;

		return true;
	}

	public String getVariable() {
		return (Convert.zeroPadInt(variesFrom.intValue(), 3) + "V" 
				+ Convert.zeroPadInt(variesTo.intValue(), 3));
	}
	
	public void setVariable(String in) {
		if (isVariable(in)) {
			variesFrom = new Integer(in.substring(0, 3));
			variesTo = new Integer(in.substring(4, 7));
		}
	}

	public String getFormattedWind() {
		StringBuffer s = new StringBuffer();

		if (direction != null) {
			if (direction.intValue() == 0) {
				s.append("calm");
			} else if (direction.intValue() == -1) {
				s.append("varies");
			} else {
				s.append("from the " + directionLookup(direction.intValue())
						+ " (" + direction + " degrees)");
			}
			s.append(" at " + Convert.ktToMph(speed.intValue()) + " mph ("
					+ speed + " knots; " + Convert.ktToMps(speed.intValue())
					+ " m/s)");
		}

		if (gust != null) {
			s.append(" gusting to " + gust);
		}

		if (variesFrom != null && variesTo != null)
			s.append(", varying from " + directionLookup(variesFrom.intValue()) + " ("
					+ variesFrom + " degrees) to " + directionLookup(variesTo.intValue())
					+ " (" + variesTo + " degrees)");

		return s.toString();
	}

	public String toString() {
		StringBuffer s = new StringBuffer();

		if (direction != null) {
			if (direction.intValue() == -1) {
				s = s.append("VRB");
			} else {
				s = s.append(Convert.zeroPadInt(direction.intValue(), 3));
			}
		}

		if (speed != null)
			s.append(Convert.zeroPadInt(speed.intValue(), 2));

		if (gust != null)
			s.append("G" + Convert.zeroPadInt(gust.intValue(), 2));

		if (s.length() > 0)
			s.append("KT");

		if (variesFrom != null && variesTo != null)
			s.append(" " + getVariable());

		return s.toString();
	}
}