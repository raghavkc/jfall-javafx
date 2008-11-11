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
 * MetarFtp.java
 *
 * Extract the METAR (Aviation Routine Weather Report) observation date
 * and data from a file retrieved from the National Oceanic & Atmospheric
 * Administration (NOAA).
 *
 * Files have the format:
 *
 *      yyyy/mm/dd hh:mm
 *      METAR OBSERVATION STRING (can be on more than one line)
 *
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.2, 01/22/2005
 */

package com.feldt.metar;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.TimeZone;

import com.feldt.metar.exceptions.MetarException;

public class MetarFtp {
	private Date observationDate;
	private String observation;

	private MetarFtp() {
	}

	public static MetarFtp parse(String station) throws MetarException {
		
		if (station == null) {
			return null;
		}
		
		try {
			Properties metarProperties = new Properties();
			metarProperties.load(new FileInputStream("metar.properties"));
			String urlString = metarProperties.getProperty("ftpURL");
		
			if (urlString == null) {
				throw new Exception("Unable to find ftpURL property in property.file.");
			}
			
			urlString = urlString.concat(station.toUpperCase().concat(".TXT"));
	
			// open a connection to the URL
			URL url = new URL(urlString);
			URLConnection conn = url.openConnection();
			conn.setDoInput(true);
			conn.connect();
		
			BufferedReader reader = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));

			MetarFtp metarFtp = new MetarFtp();
			String buf;
	
			// attempt to read the first line from the file
			if ((buf = reader.readLine()) == null) {
				throw new Exception("no data in InputStream");
			}
	
			// first line should be the date and time of the observation
			TimeZone tz = TimeZone.getTimeZone("UTC");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd kk:mm");
			sdf.setTimeZone(tz);
			sdf.setLenient(false); // force strict parsing
			Date date = sdf.parse(buf);

			if (date == null) {
				throw new Exception("unable to parse date from InputStream");
			} else {
				GregorianCalendar gc = new GregorianCalendar(tz);
				gc.setTime(date);
				metarFtp.setObservationDate(gc.getTime());
			}

			// the remaining lines of the file should be the observation string
			StringBuffer out = new StringBuffer();
			while ((buf = reader.readLine()) != null) {
				out.append(buf);
			}

			// we should have read something...
			if (out.length() <= 0)
				throw new IOException("no observation string in InputStream");
	
			metarFtp.setObservation(out.toString());
			
			return metarFtp;
			
		} catch (Exception e) {
			throw new MetarException(e.getMessage());
		}
	}

	public void setObservationDate(Date observationDate) {
		this.observationDate = (Date) observationDate.clone();
	}
	public Date getObservationDate() {
		return observationDate;
	}
	public String getObservationDateAsString() {
		TimeZone tz = TimeZone.getTimeZone("UTC");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd kk:mm");
		sdf.setTimeZone(tz);
		return sdf.format(observationDate);
	}
	public void setObservation(String observation) {
		this.observation = observation;
	}
	public String getObservation() {
		return observation;
	}
}