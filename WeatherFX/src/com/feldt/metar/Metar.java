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
 * Metar.java
 *
 * Class to parse and represent METAR (Aviation Routine Weather Report)
 * observation data.
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.7, 01/25/2005
 */

package com.feldt.metar;


import java.io.FileInputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.Vector;

import com.feldt.metar.exceptions.MetarParseException;
import com.feldt.metar.tools.Convert;


public class Metar {
	private String station;
	private Date date;
	private Wind wind;
	private Visibility visibility;
	private Vector conditions;
	private Vector clouds;
	private Temperature temperature;
	private Altimeter altimeter;
	private Boolean corrected;
        private Pressure pressure;

    public Pressure getPressure() {
        return pressure;
    }

    public void setPressure(Pressure pressure) {
        this.pressure = pressure;
    }

	private Metar() {
		conditions = new Vector();
		clouds = new Vector();
		corrected = Boolean.FALSE;
	}	

	public static boolean isDate(String date) {
		if (date == null) {
			return false;
		}
		
		if (date.matches("\\d{6}Z")) {
			return true;
		}
		
		return false;
	}
	/**
	 * metar data only provides a two digit field with a day of the month
	 * value. FTP files and HTTP files both have the date within them and
	 * this method matches those two dates
	 */
	public static boolean metarReportDateMatches(String in, String metarReportDate) {
		
		if (in == null || metarReportDate == null) {
			return false;
		}
		
		// DDHHMMZ
		if (! in.matches("\\d{6}Z")) {
			return false;
		}
		
		// YYYY/MM/DD HH:MM
		if (! metarReportDate.matches("\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}")) {
			return false;
		}
		
		// match date
		if (! metarReportDate.substring(8,10).equals(in.substring(0,2))) {
			return false;
		}
		
		// match hour
		if (! metarReportDate.substring(11,13).equals(in.substring(2,4))) {
			return false;
		}
		
		// match minute
		if (! metarReportDate.substring(14,16).equals(in.substring(4,6))) {
			return false;
		}
		
		return true;
	}


	private void parseDate(String metarReportDate) {
		if (metarReportDate == null) {
			return;
		}
		
		TimeZone tz = TimeZone.getTimeZone("UTC");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd kk:mm");
		sdf.setTimeZone(tz);
		sdf.setLenient(false); // force strict parsing

		try {
			date = sdf.parse(metarReportDate);
			if (date != null) {
				GregorianCalendar gc = new GregorianCalendar(tz);
				gc.setTime(date);
				date = gc.getTime();
			}
	    } catch (ParseException e) {
	    }
	}

	public static Metar parse(String station, String metarData,
		    String metarReportDate) throws MetarParseException {
		
		if (station == null || metarData == null) {
			return null;
		}
		
		Metar metar = new Metar();
		StringTokenizer st = new StringTokenizer(metarData);
		String token, lastToken = null;

		while (st.hasMoreTokens()) {
			token = st.nextToken();

			if (token.equalsIgnoreCase(station))
				metar.setStation(station.toUpperCase());

			else if (token.equals("RMK")) {
				// TODO: currently ignoring everything in the remark
				// and there is some good data in there...
				break;
			}

			else if (token.equals("COR")) {
				metar.setCorrected(Boolean.TRUE);
			}

			else if (Metar.isDate(token)) {
                            metar.parseDate(token);
//				if (Metar.metarReportDateMatches(token, metarReportDate)) {
//					metar.parseDate(metarReportDate);
//				} else {
//					throw new MetarParseException("Date token: \"" 
//							+ token + "\" does not match metar report date: "
//							+ metarReportDate);
//				}
			}

			else if (Wind.isAWind(token)) {
				metar.setWind(Wind.parseWind(token));
			}
                        
                                                else if (Pressure.isAPressure(token)) {
                            metar.setPressure(Pressure.parsePressure(token));
                        }

			else if (Wind.isVariable(token)) {
				metar.getWind().setVariable(token);
			}

			else if (Temperature.isATemperature(token)) {
				metar.setTemperature(Temperature.parseTemperature(token));
			}

			else if (Condition.isACondition(token)) {
				metar.addCondition(Condition.parseCondition(token));
			}

			else if (Cloud.isACloud(token)) {
				metar.addCloud(Cloud.parseCloud(token));
			}

			else if (Altimeter.isAAltimeter(token)) {
				metar.setAltimeter(Altimeter.parseAltimeter(token));
			} 
                        


			// if lastToken is not null then it has to be the first part of
			// a visibility string otherwise its an unknown token
			else if (lastToken != null && (! Visibility.isAVisibility(token))) {
//				throw new MetarParseException("Unknown token: \""
//					+ lastToken + "\" in \"" + metarData + "\"");
			}

			else if (Visibility.isAVisibility(token)) {
				if (lastToken != null) {
					metar.setVisibility(Visibility.parseVisibility(lastToken + " " + token));
					lastToken = null;
				} else {
				    metar.setVisibility(Visibility.parseVisibility(token));
				}
			}

			// no other token is an solely an integer so this could be part
			// of a fractional visibility
			else if ((metar.visibility == null) && Convert.isPositiveInteger(token)) {
				lastToken = token;
			}

			// anything not recognized before here is an error
			else {
//				throw new MetarParseException("Unknown token: \""
//					+ token + "\" in \"" + metarData + "\"");
			}
		}

		return metar;
	}
	
	public String getFormattedDate(boolean detailed) {
		if (date == null) {
			return "";
		}
		
		SimpleDateFormat sdf;

		if (detailed) {
			sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a z");
			return sdf.format(date);
		} else {
			TimeZone tz = TimeZone.getTimeZone("UTC");
			sdf = new SimpleDateFormat("ddHHmm");
			sdf.setTimeZone(tz);
			return sdf.format(date) + "Z";
		}
	}

	public String getFormattedConditions() {
		if (conditions.size() <= 0) {
			return "";
		}

		StringBuffer s = new StringBuffer();
		
		for (int i = 0; i < conditions.size(); i++) {
			Condition condition = (Condition)conditions.get(i);
			s.append(condition.getFormattedCondition());
			if ((i+1) < conditions.size()) {
				s.append(", ");
			}
		}

		return s.toString();
	}

	public String getFormattedClouds() {
		if (clouds.size() <= 0) {
			return "";
		}

		StringBuffer s = new StringBuffer();
		
		for (int i = 0; i < clouds.size(); i++) {
			s.append(((Cloud)clouds.get(i)).getFormattedCloud());
			if ((i+1) < clouds.size()) {
				s.append(", ");
			}
		}
		
		return s.toString();
	}

	public String getFormattedMetar() {
		StringBuffer s = new StringBuffer();
		String newLine = System.getProperty("line.separator");
		
		if (station != null) {
			String formattedStation = station;
			try {
				Properties metarProperties = new Properties();
				metarProperties.load(new FileInputStream("metar.properties"));
				formattedStation = (String)metarProperties.get(station);
				if (formattedStation == null) {
					formattedStation = station;
				}
			} catch (Exception e) {
				// do nothing...
			}
			s.append("Conditions at: " + formattedStation + newLine);
		}

		
			
		if (date != null)
			s.append("Time: " + getFormattedDate(true) + newLine);
		if (wind != null)
			s.append("Wind: " + wind.getFormattedWind() + newLine);
		if (visibility != null)
			s.append("Visibility: " + visibility.getFormattedVisibility() + newLine);
		if (conditions.size() > 0)
			s.append("Weather Conditions: " + getFormattedConditions() + newLine);
		if (clouds.size() > 0)
			s.append("Sky Conditions: " + getFormattedClouds() + newLine);
		if (temperature != null) {
			s.append("Temperature: " + temperature.getFormattedTemperature() + newLine);
			s.append("Dew Point: " + temperature.getFormattedDewPoint() + newLine);
			s.append("Relative Humidity: " + temperature.getFormattedHumidity() + newLine);
		}
		if (altimeter != null)
			s.append("Pressure (altimeter): " + altimeter.getFormattedAltimeter() + newLine);

		return s.toString();
	}

	public String toString() {
		StringBuffer s = new StringBuffer();

		if (station != null) {
			s.append(station + " ");
		}
		if (date != null) {
			s.append(getFormattedDate(false) + " ");
		}
		if (corrected.booleanValue()) {
			s.append("COR ");
		}
		if (wind != null) {
			s.append(wind.toString() + " ");
		}
		if (visibility != null) {
			s.append(visibility.toString() + " ");
		}
		if (conditions.size() > 0) {
			StringBuffer conditionString = new StringBuffer();
			
			for (int i = 0; i < conditions.size(); i++) {
				Condition condition = (Condition)conditions.get(i);
				conditionString.append(condition.toString());
				if (i+1 < conditions.size()) {
					conditionString.append(" ");
				}
			}
			s.append(conditionString.toString() + " ");
		}
		if (clouds.size() > 0) {
			StringBuffer cloudString = new StringBuffer();
			
			for (int i = 0; i < clouds.size(); i++) {
				Cloud cloud = (Cloud)clouds.get(i);
				cloudString.append(cloud.toString());
				if (i+1 < clouds.size()) {
					cloudString.append(" ");
				}
			}
			s.append(cloudString.toString() + " ");
		}
		if (temperature != null) {
			s.append(temperature.toString() + " ");
		}
		if (altimeter != null) {
			s.append(altimeter.toString());
		}

		return s.toString();
	}
	
	public String getStation() {
		return station;
	}
	public void setStation(String station) {
		this.station = station;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = (Date)date.clone();
	}
	public Vector getConditions() {
		return conditions;
	}
	public void setConditions(Vector conditions) {
		this.conditions = conditions;
	}
	public void addCondition(Condition condition)  {
		conditions.add(condition);
	}
	public Vector getClouds() {
		return clouds;
	}
	public void setClouds(Vector clouds) {
		this.clouds = clouds;
	}
	public void addCloud(Cloud cloud) {
		clouds.add(cloud);
	}
	public Visibility getVisibility() {
		return visibility;
	}
	public void setVisibility(Visibility visibility) {
		this.visibility = visibility;
	}
	public Wind getWind() {
		return wind;
	}
	public void setWind(Wind wind) {
		this.wind = wind;
	}
	public Altimeter getAltimeter() {
		return altimeter;
	}
	public void setAltimeter(Altimeter altimeter) {
		this.altimeter = altimeter;
	}
	public Boolean getCorrected() {
		return corrected;
	}
	public void setCorrected(Boolean corrected) {
		this.corrected = corrected;
	}
	public Temperature getTemperature() {
		return temperature;
	}
	public void setTemperature(Temperature temperature) {
		this.temperature = temperature;
	}
}