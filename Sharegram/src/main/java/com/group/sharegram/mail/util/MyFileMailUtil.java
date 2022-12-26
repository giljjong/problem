package com.group.sharegram.mail.util;

import java.io.File;
import java.util.Calendar;
import java.util.UUID;
import java.util.regex.Matcher;

import org.springframework.stereotype.Component;

@Component
public class MyFileMailUtil {

		private String sep = Matcher.quoteReplacement(File.separator);
		
		public String getFilename(String filename) {
			
			String extension = null;
			
			if(filename.endsWith("tar.gz")) {
			
				extension = "tar.gz";

			} else {
				
				String[] arr = filename.split("\\.");  // 정규식에서 .(마침표) 인식 : \. 또는 [.]
				
				extension = arr[arr.length - 1];
				
			}
			
			return UUID.randomUUID().toString().replaceAll("\\-", "") + "." + extension;
			
		}

		public String getTodayPath() {
			Calendar calendar = Calendar.getInstance();
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH) + 1;
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			return "/storage" + sep + year + sep + makeZero(month) + sep + makeZero(day);  // 루트/storage
		}
		
		public String getYesterdayPath() {
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.DATE, -1);  // 1일 전
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH) + 1;
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			return "/storage" + sep + year + sep + makeZero(month) + sep + makeZero(day);  // 루트/storage
		}
		
		public String getTempPath() {
			return "/storage" + sep + "temp";
		}
		
		public String getSummernotePath() {
			return "/storage" + sep + "summernote";
		}
		
		public String makeZero(int n) {
			return (n < 10) ? "0" + n : "" + n;
		}
}