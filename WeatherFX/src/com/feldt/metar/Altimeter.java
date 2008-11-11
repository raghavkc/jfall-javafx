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
 * Altimeter.java
 *
 * class representing METAR altimeter information
 *
 * Altimeter setting: indicator and 4 digits; in U.S.,
 * A-inches and hundredths; (Q-hectoPascals, e.g. Q1013)
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7 01/21/2005
 */
package com.feldt.metar;

import com.feldt.metar.tools.Convert;

public class Altimeter {

	private Float altimeter;
	
	private Altimeter() {
	}
	
	public static boolean isAAltimeter(String metarString) {

		if (metarString == null) {
			return false;
		}
		
		if (metarString.length() != 5) {
			return false;
		}

		if (metarString.charAt(0) != 'A' && metarString.charAt(0) != 'Q') {
			return false;
		}

		for (int i = 1; i < 5; i++) {
			if (! Convert.isDigit(metarString.charAt(i))) return false;
		}

		return true;
	}
	
	public static Altimeter parseAltimeter(String metarString) {
		if (!isAAltimeter(metarString)) {
			return null;
		}
		
		Altimeter altimeter = new Altimeter();
		char[] buf = metarString.toCharArray();
		int inches, hundredths;

		if (buf[0] == 'A') {
			char[] fString = new char[5];
			fString[0] = buf[1];
			fString[1] = buf[2];
			fString[2] = '.';
			fString[3] = buf[3];
			fString[4] = buf[4];
			altimeter.setAltimeter(new Float(new String(fString)));
		} else { // by default must be Q
			altimeter.setAltimeter(new Float(Convert.hPaToInches(Float.parseFloat(metarString.substring(1)))));
		}
		
		return altimeter;
	}
	
	public String getFormattedAltimeter() {
		return altimeter + " in. Hg (" +
			(int)Convert.inchesToHPa(altimeter.floatValue()) + " hPa)";
	}
	
	public String toString() {
		return "A" + Integer.toString((int)(altimeter.floatValue()*100));
	}
	
	public Float getAltimeter() {
		return altimeter;
	}
	public void setAltimeter(Float altimeter) {
		this.altimeter = altimeter;
	}
}
