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
 * Convert.java
 *
 * conversion and utility functions for manipulating weather data
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/22/2005
 */

package com.feldt.metar.tools;

import java.util.StringTokenizer;


public class Convert {
	/**
	 * convert fahrenheit temperature <code>f</code>
	 * to celsius
	 *
	 * @param
	 * @return
	 */
	public static int fToC(int f) {
		return (int)((f - 32) * 0.55555556);
	}

	/**
	 * convert celsius (c) to fahrenheit (f)
	 */
	public static int cToF(int c) {
		return (int)((c * 1.8) + 32);
	}

	/**
	 * convert knots (kt) to miles per hour (mph)
	 */
	public static int ktToMph(int k) {
		return (int)(k * 1.1507794);
	}

	/**
	 * convert knots (kt) to meters per second (m/s)
	 */
	public static int ktToMps(int k) {
		return (int)(k * 0.514444);
	}

	/**
	 * convert statute miles (sm) to kilometers (km)
	 */
	public static int smToKm(int m) {
		return (int)(m * 1.6092);
	}

	/**
	 * convert statute miles (sm) to kilometers (km)
	 */
	public static float smToKm(float f) {
		return (f * 1.6092F);
	}

	/**
	 * convert hectoPascals (hPa) to inches of mercury (Hg)
	 */
	public static float hPaToInches(float h) {
		return (float)(h * 0.02952875);
	}

	/**
	 * convert inches of mercury (Hg) to hectoPascals (hPa)
	 */
	public static float inchesToHPa(float i) {
		return (float)(i * 33.8653);
	}

	/**
	 * compute relative humidy from temperature and dewpoint
	 */
	public static int calcHumidity(int t, int d) {
		double temp1 = 6.11 * Math.pow(10.0, (7.5 * t) / (237.7 + t));
		double temp2 = 6.11 * Math.pow(10.0, (7.5 * d) / (237.7 + d));

		return (int)((temp2 / temp1) * 100);
	}

	/**
	 * determine if character 'c' is a digit [0-9]
	 */
	public static boolean isDigit(char c) {
		if (c < '0' || c > '9') return false;

		return true;
	}

	/**
	 * determine if a string is an integer greater or equal to 0
	 */
	public static boolean isPositiveInteger(String s) {
		try {
			if (Integer.parseInt(s) >= 0) return true;
		} catch(NumberFormatException e) {
			// fall through to return false
		}
		return false;
	}

	/**
	 * helper function to convert a byte array to an integer
	 */
	public static int bytesToInt(char[] buf) {
		return bytesToInt(buf, 0, buf.length);
	}

	/**
	 * convert a bound <code>char</code> array to an integer
	 */
	public static int bytesToInt(char[] buf, int begin, int end) {
		int sum = 0;

		if (end > buf.length) end = buf.length;

		for (int i = begin; i < end; i++) {
			sum = (sum * 10) + (buf[i] - '0');
		}

		return sum;
	}

	/**
	 * return an <code>String</code> representation of <code>int</code> x
	 * padding with leading zeros if shorter than <code>len</code>
	 */
	public static String zeroPadInt(int x, int len) {
		String s = Integer.toString(x);

		if (s.length() < len) {
			int buflen = len - s.length();
			char[] buf = new char[buflen];
			for (int i = 0; i < buflen; i++)
				buf[i] = '0';
			s = new String(buf).concat(s);
		}
		return s;
	}

	/**
	 * convert a <code>String</code> representation of a mixed numeral
	 * to a <code>float</code>
	 */
	public static float mixedToFloat(String s) throws IllegalArgumentException {
		int wholeNumber, numerator, denominator;
		float f;

		StringTokenizer st = new StringTokenizer(s, " /");

		try {
			switch(st.countTokens()) {
	    		case 1: {
					wholeNumber = Integer.parseInt(st.nextToken());
		    		f = (float)wholeNumber;
					break;
	    		}
			    case 3: {
					wholeNumber = Integer.parseInt(st.nextToken());
					numerator = Integer.parseInt(st.nextToken());
					denominator = Integer.parseInt(st.nextToken());
					//f = (float)wholeNumber + (float)(numerator/denominator);
					f = (float)wholeNumber + (float)numerator/(float)denominator;
					break;
			    }
				default:
	    		    throw new
						IllegalArgumentException(s + ": not a mixed numeral");
			}
		} catch(NumberFormatException e) {
			throw new IllegalArgumentException(s + ": not a mixed numeral");
		}

		return f;
	}
}
