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
 * Cloud.java
 *
 * class representing METAR cloud information
 *
 * Cloud amount, height and type: SKy
 * Clear 0/8, FEW >0/8-2/8,
 * SCaTtered 3/8-4/8, BroKeN 5/8-7/8,
 * OVerCast 8/8; 3-digit height in hundreds of ft;
 * Towering CUmulus or CumulonimBus in
 * METAR; in TAF, only CB.
 * Vertical Visibility for obscured sky and
 * height "VV004". More than 1 layer may be reported
 * or forecast. In automated METAR reports only, CLeaR
 * for "clear below 12,000 feet"
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7 01/21/2005
 */

package com.feldt.metar;

import com.feldt.metar.tools.Convert;


public class Cloud {
	private String amount;
	private String type;
	private Integer height;

	private Cloud() {
	}

	public static boolean isACloud(String metarString) {
		
		if (metarString == null) {
			return false;
		}
		
		char[] buf = metarString.toCharArray();
		int i = 0;

		// SKC - manual station, no layers observed
		// CLR - automated station, no layers up to 12000 feet
		if ((buf.length == 3) && (metarString.equals("SKC") || (metarString.equals("CLR"))))
			return true;

		if (metarString.startsWith("VV")) {
			i += 2;
		} else if (metarString.startsWith("FEW") || metarString.startsWith("SCT") ||
			    metarString.startsWith("BKN") || metarString.startsWith("OVC")) {
			i += 3;
		} else {
			return false;
		}

		if ((i+3) <= buf.length) {
			int endIndex = i+3;
			for (int j = i; j < endIndex; j++) {
				if (!Character.isDigit(buf[j])) {
					return false;
				}
			}
			i += 3;
		} else {
			return false;
		}

		if (i == buf.length) 
			return true;

		if (metarString.substring(i).equals("TCU") || metarString.substring(i).equals("CB"))
			return true;
		else
			return false;
	}


	public static Cloud parseCloud(String metarString) {
		
		if (!isACloud(metarString)) {
			return null;
		}
		
		Cloud cloud = new Cloud();
		int i = 0;

		if (metarString.startsWith("VV")) {
			 cloud.setAmount(metarString.substring(0, 2));
			 i += 2;
		} else {
		    cloud.setAmount(metarString.substring(0, 3));
			i += 3;
		}

		if ((i+3) <= metarString.length()) {
			cloud.setHeight(new Integer(metarString.substring(i, (i+3))));
			i += 3;
		}

		if (i < metarString.length()) 
			cloud.setType(metarString.substring(i));
		
		return cloud;
	}


	// lookup cloud amount, return the input parameter if not found
	public static String lookupCloudAmount(String s) {
		if (s.equals("SKC")) return "clear sky";
		else if (s.equals("CLR")) return "clear sky";
		else if (s.equals("FEW")) return "few clouds";
		else if (s.equals("SCT")) return "scattered clouds";
		else if (s.equals("BKN")) return "broken clouds";
		else if (s.equals("OVC")) return "overcast";
		else if (s.equals("VV")) return "vertical visibility";
		else return s;
	}


	// lookup cloud type, return the input parameter if not found
	public static String lookupCloudType(String s) {
		if (s.equals("TCU")) return "towering cumulus";
		else if (s.equals("CB")) return "cumulonimbus";
		else return s;
	}


	public String getFormattedCloud() {
		StringBuffer s = new StringBuffer();

		if (amount != null)
	        s.append(lookupCloudAmount(amount));

		if (height != null)
			s.append(" at " + Integer.toString(height.intValue()*100) + " feet");

		if (type != null)
			s.append(" (" + lookupCloudType(type) + ")");

		return s.toString();
	}


	public String toString() {
		StringBuffer s = new StringBuffer();

		if (amount != null)
			s.append(amount);

	    if (height != null)
			s.append(Convert.zeroPadInt(height.intValue(), 3));

		if (type != null)
			s.append(type);

		return s.toString();
	}
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public Integer getHeight() {
		return height;
	}
	public void setHeight(Integer height) {
		this.height = height;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}