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
 * Condition.java
 * 
 * class representing METAR weather phenomena
 * 
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/21/2005
 */

package com.feldt.metar;

import java.util.*;

class Condition {
	private String condition;

	private Condition() {
	}

	private static Hashtable createConditionTable() {
		Hashtable conditionTable = new Hashtable(34);

		// intensity or proximity
		conditionTable.put("-", "light");
		conditionTable.put("+", "heavy");
		conditionTable.put("VC", "in vicinity: ");

		// qualifiers
		conditionTable.put("MI", "shallow");
		conditionTable.put("BC", "patches");
		conditionTable.put("SH", "showers");
		conditionTable.put("PR", "partial");
		conditionTable.put("TS", "thunderstorm");
		conditionTable.put("BL", "blowing");
		conditionTable.put("DR", "drifting");
		conditionTable.put("FZ", "freezing");

		// phenomena
		conditionTable.put("DZ", "drizzle");
		conditionTable.put("RA", "rain");
		conditionTable.put("SN", "snow");
		conditionTable.put("SG", "snow grains");
		conditionTable.put("IC", "ice crystals");
		conditionTable.put("PL", "ice pellets");
		conditionTable.put("GR", "hail");
		conditionTable.put("GS", "small hail/snow pellets");
		conditionTable.put("UP", "unknown precipitation");
		conditionTable.put("BR", "mist");
		conditionTable.put("FG", "fog");
		conditionTable.put("FU", "smoke");
		conditionTable.put("VA", "volcanic ash");
		conditionTable.put("SA", "sand");
		conditionTable.put("HZ", "haze");
		conditionTable.put("PY", "spray");
		conditionTable.put("DU", "widespread dust");
		conditionTable.put("SQ", "squall");
		conditionTable.put("SS", "sandstorm");
		conditionTable.put("DS", "duststorm");
		conditionTable.put("PO", "well developed dust/sand whirls");
		conditionTable.put("FC", "funnel cloud");
		conditionTable.put("+FC", "tornado/waterspout");

		return conditionTable;
	}

	public static boolean isACondition(String metarString) {

		if (metarString == null) {
			return false;
		}

		char[] buf = metarString.toCharArray();
		Hashtable conditionTable = createConditionTable();
		boolean found;
		int i = 0;

		if (buf.length < 2 || buf.length > 8)
			return false;

		if ((buf[i] == '-' || buf[i] == '+') && !metarString.startsWith("+FC"))
			i++;

		while ((i + 2) <= buf.length) {
			found = false;

			if (conditionTable.containsKey(metarString.substring(i, i + 2))) {
				found = true;
				i += 2;
			}

			// look for the odd tornado/waterspout token along the way
			if (((i + 3) <= buf.length) && metarString.substring(i, i + 3).equals("+FC")) {
				found = true;
				i += 3;
			}

			if (!found)
				break;
		}

		// if we didn't match all the tokens its not a condition...
		if (i == buf.length) {
			return true;
		} else {
			return false;
		}
	}

	public static Condition parseCondition(String metarString) {

		if (!isACondition(metarString)) {
			return null;
		}

		Condition condition = new Condition();
		char[] buf = metarString.toCharArray();
		Hashtable conditionTable = createConditionTable();
		StringBuffer conditionString = new StringBuffer();
		int i = 0;

		if ((buf[i] == '-' || buf[i] == '+') && !metarString.startsWith("+FC")) {
			conditionString.append(new String(buf, 0, 1));
			i++;
		}

		while ((i + 2) <= buf.length) {
			if (conditionTable.containsKey(metarString.substring(i, i + 2))) {
				conditionString.append(new String(buf, i, 2));
				i += 2;
			}

			if (((i + 3) <= buf.length) && metarString.substring(i, i + 3).equals("+FC")) {
				conditionString.append("+FC");
				i += 3;
			}
		}
		
		condition.setCondition(conditionString.toString());
		return condition;
	}

	public boolean hasCondition(String needle) {
		if (needle == null) {
			return false;
		}
		if (condition == null) {
			return false;
		}
		
		if (condition.indexOf(needle) < 0) {
			return false;
		}
		
		return true;
	}

	public String getFormattedCondition() {

		if (condition == null) {
			return null;
		}
		
		StringBuffer s = new StringBuffer();
		Hashtable conditionTable = createConditionTable();
		String conditionString = condition;

		while (conditionString.length() > 0) {
			if (conditionString.charAt(0) == '-' || conditionString.charAt(0) == '+') {
				s.append(conditionTable.get(conditionString.substring(0, 1)) + " ");
				conditionString = conditionString.substring(1);
			} else if (conditionString.startsWith("+FC")) {
				s.append(conditionTable.get(conditionString.substring(0, 3)) + " ");
				conditionString = conditionString.substring(3);
			} else if (conditionString.length() >= 2) {
				s.append(conditionTable.get(conditionString.substring(0, 2)) + " ");
				conditionString = conditionString.substring(2);
			} else {
				break;
			}
		}
		
		return s.toString().trim();
	}

	public String toString() {
		return condition;
	}

	public String getCondition() {
		return condition;
	}
	public void setCondition(String condition) {
		this.condition = condition;
	}
}