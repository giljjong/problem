package com.gdu.semi.util;

import java.io.File;
import java.util.Calendar;
import java.util.UUID;
import java.util.regex.Matcher;

import org.springframework.stereotype.Component;

@Component
public class MyFileUtil {

	public String getFilename(String filename) {
		
		String extension = null;
		if (filename.endsWith("tar.gz")) {  //확자아 더 추가하기
			extension = "tar.gz";
		} else {
			String[] arr = filename.split("\\.");
			extension = arr[arr.length-1];
		}
		return UUID.randomUUID().toString().replaceAll("\\-", "") + "." + extension;
	}
	
	public String getTodayPath() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) +1 ;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		String sep = Matcher.quoteReplacement(File.separator);
		return "storage" + sep  + year + sep + makeZero(month) + sep + makeZero(day);
		
	}
	
	public String getYesterdayPath() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		String sep = Matcher.quoteReplacement(File.separator);
		return "storage" + sep + year + sep + makeZero(month) + sep + makeZero(day);
	}
	
	public String makeZero(int n) {
		return (n < 10 ) ? "0" + n : "" + n;
	}
	
}
