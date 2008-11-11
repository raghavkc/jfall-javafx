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

package com.feldt.metar.exceptions;

/**
 * MetarParseException.java
 * 
 * Parse Exception object for com.feldt.metar package
 * 
 * @author Matthew Feldt <developer@feldt.com>
 * @version 0.1 01/17/2005 23:35
 */
public class MetarParseException extends Exception {

	public MetarParseException(String msg) {
		super(msg);
	}

}