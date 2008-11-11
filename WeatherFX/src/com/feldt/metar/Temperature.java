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
 * Temperature.java
 *
 * class representing METAR temperature information
 *
 *
 * Temperature: degrees Celsius; first 2 digits,
 * temperature "/" last 2 digits, dew-point temperature;
 * Minus for below zero, e.g., M06
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/21/2005
 */

package com.feldt.metar;

import com.feldt.metar.tools.Convert;

class Temperature {
	private Integer temperature;
	private Integer dewPoint;
	private Integer humidity;

	private Temperature() {
	}

	public static boolean isATemperature(String metarString) {
		
		if (metarString == null) {
			return false;
		}
		
		int c, dewpoint;
		char[] buf = metarString.toCharArray();
		int i = 0;

		if (buf.length < 5) return false;

		if (buf[i] == 'M') 
			i++;

		if ((!Character.isDigit(buf[i])) || (!Character.isDigit(buf[++i]))) 
			return false;

		if (buf[++i] != '/') 
			return false;

		if (buf[++i] == 'M') 
			i++;

		if ((!Character.isDigit(buf[i])) || (! Character.isDigit(buf[++i]))) 
			return false;

		return true;
	}

	public static Temperature parseTemperature(String metarString) {
		
		if (!isATemperature(metarString)) {
			return null;
		}
		
		Temperature temperature = new Temperature();
		char[] buf = metarString.toCharArray();
		int i = 0, j, value;
		boolean minus = false;

		if (buf[0] == 'M') {
			minus = true;
			i++;
		}

		for (j = i; buf[j] != '/'; j++)
			;

		value = Convert.bytesToInt(buf, i, j);
		if (minus) value = -value;
		temperature.setTemperature(new Integer(value));

		minus = false;
		i = j + 1;

		if (buf[i] == 'M') {
			minus = true;
			i++;
		}

		value = Convert.bytesToInt(buf, i, buf.length);
		if (minus) value = -value;
		temperature.setDewPoint(new Integer(value));
		
		// calculate and set humidity from temperature and dewpoint values
		temperature.humidity = new Integer(Convert.calcHumidity(
				temperature.getTemperature().intValue(), 
				temperature.getDewPoint().intValue()));
		
		return temperature;
	}

	public String getFormattedTemperature() {
		StringBuffer s = new StringBuffer();

		if (temperature != null)
		    s.append(Convert.cToF(temperature.intValue()) + " F (" 
		    		+ temperature.intValue() + " C)");

		return s.toString();
	}

	public String getFormattedDewPoint() {
		StringBuffer s = new StringBuffer();

		if (dewPoint != null)
			s.append(Convert.cToF(dewPoint.intValue()) + " F (" 
					+ dewPoint.intValue() + " C)");

		return s.toString();
	}
	
	public String getFormattedHumidity() {
		return humidity.toString() + "%";
	}

	public String toString() {
		StringBuffer s = new StringBuffer();

		if (temperature != null) {
			int temp = temperature.intValue();
			if (temp < 0) {
		    		s.append("M");
			    temp = -temp;
			}

		    s.append(Convert.zeroPadInt(temp, 2));

			s.append("/");
		}

		if (dewPoint != null) {
			int dewp = dewPoint.intValue();
			if (dewp < 0) {
		    		s.append("M");
			    dewp = -dewp;
			}
    			s.append(Convert.zeroPadInt(dewp, 2));
		}

		return s.toString();
	}
	
	public Integer getDewPoint() {
		return dewPoint;
	}
	public void setDewPoint(Integer dewPoint) {
		this.dewPoint = dewPoint;
	}
	public Integer getTemperature() {
		return temperature;
	}
	public void setTemperature(Integer temperature) {
		this.temperature = temperature;
	}
	public Integer getHumidity() {
		return humidity;
	}
	public void setHumidity(Integer humidity) {
		this.humidity = humidity;
	}
}