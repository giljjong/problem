package com.gdu.semi.batch;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Component;

import com.gdu.semi.util.MyFileUtil;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@EnableScheduling
@Component
public class DeleteWrongFiels {
	
	private MyFileUtil myFileUtil;
	
}
