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
 * Visibility.java
 * 
 * class representing METAR visibility information
 * 
 * Prevailing visibility: in U.S., Statute
 * Miles & fractions; above 6 miles in TAF
 * Plus6SM. (Or, 4-digit minimum visibility
 * in meters and as required, lowest value
 * with direction)
 * 
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/21/2005
 */

package com.feldt.metar;

import com.feldt.metar.tools.Convert;

class Visibility {
	
	private String visibility;
	private boolean lessThan;


	private Visibility() {
	}


	public static boolean isAVisibility(String metarString) {
		
		if (metarString == null) {
			return false;
		}
		
		char[] buf = metarString.toCharArray();
		int i = 0, j;
		boolean foundDigit = false, foundSpace = false, foundFraction = false;
		// lastChar can be initialized to anything other than ' ' or '/'
		char lastChar = '0';

		// must have at least one digit and end in "SM"
		if ((buf.length < 3) || (buf[buf.length - 2] != 'S')
				|| (buf[buf.length - 1] != 'M'))
			return false;

		// advance past less than indicator 'M' if present
		if (buf[0] == 'M')
			i++;

		// examine everything in front of the token ending "SM"
		for (; i < (buf.length - 2); i++) {
			if (Character.isDigit(buf[i])) {
				foundDigit = true;
			} else if (buf[i] == ' ') {
				// only permit a single space and can't be followed by '/'
				if (foundSpace || lastChar == '/')
					return false;
				foundDigit = false;
				foundSpace = true;
			} else if (buf[i] == '/') {
				// only permit a single fraction and can't be followed by ' '
				if (foundFraction || lastChar == ' ')
					return false;
				foundDigit = false;
				foundFraction = true;
			} else {
				return false;
			}
			lastChar = buf[i];
		}

		// can't be left needing a digit...
		if (! foundDigit)
			return false;

		return true;
	}

	public static Visibility parseVisibility(String metarString) {
		Visibility visibility = new Visibility();
		int beginIndex = 0;
		int endIndex = metarString.length() - 2;

		// only set lessThan if 'M' begins visibility string
		if (metarString.charAt(beginIndex) == 'M') {
			visibility.setLessThan(true);
			beginIndex++;
		}

		visibility.setVisibility(metarString.substring(beginIndex, endIndex));
		
		return visibility;
	}

	public String getFormattedVisibility() {
		StringBuffer s = new StringBuffer();

		if (lessThan)
			s.append("Less than ");

		if (visibility != null) {
			s.append(visibility + " mile(s) (");
			s.append(Convert.smToKm(Convert.mixedToFloat(visibility))
					+ " km)");
		}

		return s.toString();
	}

	public String toString() {
		StringBuffer s = new StringBuffer();
		
		if (lessThan)
			s.append("M");

		if (visibility != null)
			s.append(visibility + "SM");

		return s.toString();
	}
	
	private void setVisibility(String visibility) {
		this.visibility = visibility;
	}
	public String getVisibility() {
		return visibility;
	}
	private void setLessThan(boolean lessThan) {
		this.lessThan = lessThan;
	}
	public boolean isLessThan() {
		return lessThan;
	}
}