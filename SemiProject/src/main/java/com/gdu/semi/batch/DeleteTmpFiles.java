package com.gdu.semi.batch;

import java.io.File;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@EnableScheduling
@Component
public class DeleteTmpFiles {

		@Scheduled(cron= "0 0 4 * * *") // 초 분 시 일 월 주 년
		public void execute() {
			String temPath = "storage" + File.separator + "temp" ; // File.separator는 프로그램이 실행 중인 OS에 해당 구분자를 리턴
			File temDir = new File(temPath);
			
			if(temDir.exists()) {
				File[] tmpFiles = temDir.listFiles(); //temDir 파일들을 필터링하고 그결과를 배열로 반환
				for(File tmp : tmpFiles ) {
					tmp.delete();
				}
			}
			
		}
}
