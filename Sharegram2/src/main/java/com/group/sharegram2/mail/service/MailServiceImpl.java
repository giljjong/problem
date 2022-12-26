package com.group.sharegram2.mail.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.group.sharegram2.addr.domain.EmpAddrDTO;
import com.group.sharegram2.mail.domain.MailAtchDTO;
import com.group.sharegram2.mail.domain.MailDTO;
import com.group.sharegram2.mail.domain.ReceiversDTO;
import com.group.sharegram2.mail.domain.SummernoteImageDTO;
import com.group.sharegram2.mail.util.MailIUtil;
import com.group.sharegram2.mail.util.MyFileUtil;
import com.group.sharegram2.mail.util.PageUtil;
import com.group.sharegram2.mapper.AddressMapper;
import com.group.sharegram2.mapper.EmpMapper;
import com.group.sharegram2.mapper.MailMapper;

import net.coobird.thumbnailator.Thumbnails;

@Service
public class MailServiceImpl implements MailService {
	
	@Autowired
	private MailIUtil mailUtil;
	
	@Autowired
	private MailMapper mailMapper;
	
	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private PageUtil pageUtil;
	
	@Autowired
	private AddressMapper addrMapper;
	
	@Autowired
	private MyFileUtil myFileUtil;
	
	@Transactional
	@Override
	public Map<String, Object> saveMail(MultipartHttpServletRequest multipartRequest, MailDTO mail) {
		EmpAddrDTO mailUser = (EmpAddrDTO)multipartRequest.getSession().getAttribute("mailUser");
		int empNo = mailUser.getEmpNo();
		mail.setEmpNo(empNo);
		
		mail.setToAddr(mail.getStrTo().split(";"));
		
    	if (!mail.getStrCc().equals("")) mail.setCcAddr(mail.getStrCc().split(";"));
    	
    	Map<String, Object> resData = new HashMap<>();
    	

    		int result = mailMapper.insertMail(mail);
    		
    		String[] summernoteImageNames = multipartRequest.getParameterValues("summernoteImageNames");
    		List<MultipartFile> files = multipartRequest.getFiles("attachs");
    		
    		int attachResult;
    		List<MailAtchDTO> atch = new ArrayList<>();
    		String[] fileNos = multipartRequest.getParameterValues("fileNo");
    		
    		
    		if(fileNos !=  null) {
    			for(int i = 0; i < fileNos.length; i++) {
    				mailMapper.insertMailAttachByFileNo(Integer.parseInt(fileNos[i]));
    			}
    		}
    		
    		for(MultipartFile multipartFile : files) {
    			
    			try {
    				
    				if(result > 0) {
    					
    					if(summernoteImageNames !=  null) {
    						for(String filesystem : summernoteImageNames) {
    							SummernoteImageDTO summernoteImage = SummernoteImageDTO.builder()
    									.filesystem(filesystem)
    									.build();
    							mailMapper.insertSummernoteImage(summernoteImage);
    						}
    					}
    					
    				
	    				// 첨부가 있는지 점검
	    				if(multipartFile != null && multipartFile.isEmpty() == false) {  // 둘 다 필요함
	    					
	    					
    						if(files.get(0).getSize() == 0) {  // 첨부가 없는 경우 (files 리스트에 [MultipartFile[field="files", filename=, contentType=application/octet-stream, size=0]] 이렇게 저장되어 있어서 files.size()가 1이다.
    							attachResult = files.size();
    						} else {
    							attachResult = 0;
    						}
	    					
	    					// 원래 이름
	    					String originName = multipartFile.getOriginalFilename();
	    					// IE는 origin에 전체 경로가 붙어서 파일명만 사용해야 함
	    					originName = originName.substring(originName.lastIndexOf("\\") + 1);
	    					
	    					// 저장할 이름
	    					String changeName = myFileUtil.getFilename(originName);
	    					
	    					// 저장할 경로
	    					String mailPath = myFileUtil.getTodayPath();
	    					
	    					// 저장할 경로 만들기
	    					File dir = new File(mailPath);
	    					if(dir.exists() == false) {
	    						dir.mkdirs();
	    					}
	    					
	    					// 첨부할 File 객체
	    					File file = new File(dir, changeName);
	    					
	    					// 첨부파일 서버에 저장(업로드 진행)
	    					multipartFile.transferTo(file);
	
	    					// AttachDTO 생성
	    					MailAtchDTO attach = MailAtchDTO.builder()
	    							.originName(originName)
	    							.changeName(changeName)
	    							.mailPath(mailPath)
	    							.build();
	    					
	    					String contentType = Files.probeContentType(file.toPath());  // 이미지의 Content-Type(image/jpeg, image/png, image/gif)

	    					// 첨부파일이 이미지이면 썸네일을 만듬
	    					if(contentType != null && contentType.startsWith("image")) {
	    					
	    						// 썸네일을 서버에 저장
	    						Thumbnails.of(file)
	    							.size(50, 50)
	    							.toFile(new File(dir, "s_" + changeName));  // 썸네일의 이름은 s_로 시작함
	    						
	    						// 썸네일이 있는 첨부로 상태 변경
	    						attach.setHasThumbnail(1);
	    					
	    					}
	    					
	    					// DB에 AttachDTO 저장
	    					attachResult += mailMapper.insertMailAttach(attach);
	    					atch.add(attach);
    					}
    				}
    				
    			} catch(Exception e) {
    				e.printStackTrace();
    			}
    			
    		}  // for
    		
    		try {
    		
    		String[] toAddrs = mail.getToAddr();
    		String[] toCcs = mail.getCcAddr();
    		
    		Map<String, Object> map = new HashMap<String, Object>();
    		int receiveEmp = 0;
    		
    		for(int i = 0; i < toAddrs.length; i++) {
    			receiveEmp = Integer.parseInt(toAddrs[i].substring(0, toAddrs[i].indexOf("@")));
    			map.put("empNo", receiveEmp);
    			
    			if(empMapper.selectEmpByMap(map) != null) {
    				map.put("receiveType", "To");
    				mailMapper.insertReceivers(map);
    			}
    			receiveEmp = 0;
    			map.clear();

            }
    		
    		if(toCcs != null) {
    			for(int i = 0; i < toCcs.length; i++) {
        			receiveEmp = Integer.parseInt(toCcs[i].substring(0, toCcs[i].indexOf("@")));
        			map.put("empNo", receiveEmp);
        			
        			if(empMapper.selectEmpByMap(map) != null) {
        				map.put("receiveType", "cc");
        				mailMapper.insertReceivers(map);
        			}
        			receiveEmp = 0;
        			map.clear();

                }
    		}
    		
    		map.put("empNo", empNo);
    		map.put("receiveType", "send");
    		mailMapper.insertReceivers(map);
    		
    		boolean sendResult = mailUtil.sendMail(mailUser, mail, summernoteImageNames, atch);
    		
    		if(sendResult) {
    			resData.put("status", HttpURLConnection.HTTP_OK);
    		} else {
    			resData.put("status", HttpURLConnection.HTTP_INTERNAL_ERROR);
    		}
    		
    		return resData;
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    		resData.put("status", HttpURLConnection.HTTP_INTERNAL_ERROR);
    		return resData;
    	}
    	
	}
	
	@ResponseBody
	@Override
	public Map<String, Object> getReceiveMailList(HttpServletRequest request, String deleteCheck, String receiveType) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Optional<String> record = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(record.orElse("20"));
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("deleteCheck", deleteCheck);
		
		if(receiveType.equals("trash")) {
			map.put("trash", "true");
		}
		
		int totalRecord = mailMapper.selectReceiveMailCount(map);
		if(receiveType.equals("send")) {
			totalRecord = mailMapper.selectSendMailCount(map);
		}
		
		pageUtil.setPageUtil(page, totalRecord, recordPerPage);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		List<MailDTO> mailList = mailMapper.selectReceiveMailList(map);
		int nReadCnt = mailMapper.selectReadNotReceiveCount(map);
		if(receiveType.equals("send")) {
			mailList = mailMapper.selectSendMailList(map);
			nReadCnt = mailMapper.selectReadNotSendCount(empNo);
		}
		
		for (MailDTO mailInfo : mailList) {
			
			if((receiveType.equals("trash") && mailInfo.getReceiveType().equals("send")) || receiveType.equals("send")){
				int[] to = mailMapper.selectReceiveEmp(mailInfo.getMailNo());
				mailInfo.setEmpNo(to[0]);
			}
			
			EmpAddrDTO addr = addrMapper.selectEmpAddrByNo(mailInfo.getEmpNo());
			
			if(addr.getName() != null) {
				mailInfo.setEmpName(addr.getName());
			}
			
			
			Date sendDate = mailInfo.getSendDate();
			SimpleDateFormat dateFormat;
			
			switch(mailUtil.checkDateFormat(sendDate)) {
			case "overYear" : dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
							  break;
			case "overDay"  : dateFormat = new SimpleDateFormat("MM.dd HH:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
							  break;
			case "inToday"  : dateFormat = new SimpleDateFormat("a hh:mm");
							  mailInfo.setReceiveDate(dateFormat.format(sendDate));
			  				  break;
			default : break;
			}
			
        }
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("mailList", mailList);
		result.put("totalRecord", totalRecord);
		result.put("nReadCnt", nReadCnt);
		result.put("pageUtil", pageUtil);
		
		return result;
	}
	
	@Override
	public Map<String, Object> getReceiveMailInfo(HttpServletRequest request, Model model, ReceiversDTO receivData) {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("mailNo"));
		int mailNo = Integer.parseInt(opt.orElse("0"));
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("mailNo", mailNo);
		map.put("deleteCheck", receivData.getDeleteCheck());
		
		String readCheck = null;
		
		if(receivData.getReceiveType().equals("send")) {
			readCheck = mailMapper.selectSendReceiverByMap(map).getReadCheck();
		} else {
			readCheck = mailMapper.selectReceiverByMap(map).getReadCheck();
			// 널 에러 잡기
		}
		
		if(readCheck != null && readCheck.equals("N")) {
			map.put("checkType", "READ_CHECK");
			map.put("check", "Y");
			mailMapper.updateCheckByMap(map);
		}
		
		MailDTO mail = mailMapper.selectMailByMap(map);
		mail.setEmpName(addrMapper.selectEmpAddrByNo(mail.getEmpNo()).getName());
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 (E) a hh:mm", Locale.KOREAN);
		mail.setReceiveDate(dateFormat.format(mail.getSendDate()));
		mail.setReadCheck("Y");
		
		List<ReceiversDTO> receiverList = mailMapper.selectReceiverList(mailNo);
		
		List<EmpAddrDTO> addrList = new ArrayList<>();
		for (ReceiversDTO receiver : receiverList) {
			
			EmpAddrDTO addr = addrMapper.selectEmpAddrByNo(receiver.getEmpNo());
			addr.setReceiveType(receiver.getReceiveType());
			
			addrList.add(addr);
		}
		
		int totalRecord = mailMapper.selectReceiveMailCount(map);
		
		String in = request.getParameter("in");
		if(in != null && in.equals("trash")) {
			map.put("trash", "true");
		}
		int nReadCnt = mailMapper.selectReadNotReceiveCount(map);
		if(receivData.getReceiveType().equals("send")) {
			nReadCnt = mailMapper.selectReadNotSendCount(empNo);
		}
		
		model.addAttribute("mail", mail);
		model.addAttribute("addrList", addrList);
		model.addAttribute("nReadCnt", nReadCnt);
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("receivData", receivData);
		
		Map<String, Object> mailInfo = new HashMap<>();
		mailInfo.put("mail", mail);
		mailInfo.put("addrList", addrList);
		mailInfo.put("nReadCnt", nReadCnt);
		mailInfo.put("totalRecord", totalRecord);
		
		List<MailAtchDTO> attachList = mailMapper.selectMailAttachList(mailNo);
		if(attachList != null) {
			model.addAttribute("attachList", attachList);
			model.addAttribute("attachCnt", attachList.size());
			mailInfo.put("attachList", attachList);
		}
		
		return mailInfo;
		
	}
	
	@Override
	public Map<String, Object> changeRead(List<String> mailNo, List<String> readCheck, HttpServletRequest request) {
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		
		int updateResult = 0;
		
		for(int i = 0; i < mailNo.size(); i++) {
			map.put("empNo", empNo);
			map.put("checkType", "READ_CHECK");
			
			map.put("mailNo", mailNo.get(i));
			
			if(readCheck.get(i).equals("N")) {
				map.put("check", "Y");
			} else if(readCheck.get(i).equals("Y")) {
				map.put("check", "N");
			}
			
			updateResult += mailMapper.updateCheckByMap(map);
			map.clear();
		}
		
		Map<String, Object> result = new HashMap<>();
		
		if(updateResult == mailNo.size()) {
			result.put("isResult", true);
		} else {
			result.put("isResult", false);
		}
		
		return result;
	}
	
	@Override
	public Map<String, Object> moveInTrash(List<String> mailNo, String receiveType, HttpServletRequest request) {
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		
		int updateResult = 0;
		
		for(int i = 0; i < mailNo.size(); i++) {
			
			map.put("empNo", empNo);
			map.put("checkType", "DELETE_CHECK");
			map.put("mailNo", mailNo.get(i));
			
			String deleteCheck = null;
			
			if(receiveType.equals("send")) {
				ReceiversDTO checkInfo = mailMapper.selectSendReceiverByMap(map);
				deleteCheck = checkInfo.getDeleteCheck();
				map.put("receiveType", checkInfo.getReceiveType());
			} else if(receiveType.equals("ToCc")) {
				ReceiversDTO checkInfo = mailMapper.selectReceiverByMap(map);
				deleteCheck = checkInfo.getDeleteCheck();
				map.put("receiveType", checkInfo.getReceiveType());
			}
			
			if(deleteCheck.equals("N")) {
				map.put("check", "Y");
				updateResult += mailMapper.updateCheckByMap(map);
			}
			
			map.clear();

		}
		
		Map<String, Object> result = new HashMap<>();
		
		if(updateResult == mailNo.size()) {
			result.put("isDelete", true);
		} else {
			result.put("isDelete", false);
		}
		return result;
	}
	
	@Override
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		
		MultipartFile multipartFile = multipartRequest.getFile("file");
			
		String path = myFileUtil.getSummernotePath();
				
		String filesystem = myFileUtil.getFilename(multipartFile.getOriginalFilename());
		
		File dir = new File(path);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		File file = new File(path, filesystem);
		
		try {
			multipartFile.transferTo(file);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("src", multipartRequest.getContextPath() + "/load/image/" + filesystem);  // 이미지 mapping값을 반환
		map.put("filesystem", filesystem); 
		return map;
		
	}
	
	@Override
	public ResponseEntity<Resource> download(String userAgent, int fileNo) {
		
		// 다운로드 할 첨부 파일의 정보(경로, 이름)
		MailAtchDTO attach = mailMapper.selectMailAttachByNo(fileNo);
		File file = new File(attach.getMailPath(), attach.getChangeName());
		
		// 반환할 Resource
		Resource resource = new FileSystemResource(file);
		
		// Resource가 없으면 종료 (다운로드할 파일이 없음)
		if(resource.exists() == false) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		// 다운로드 되는 파일명(브라우저 마다 다르게 세팅)
		String origin = attach.getOriginName();
		try {
			
			// IE (userAgent에 "Trident"가 포함되어 있음)
			if(userAgent.contains("Trident")) {
				origin = URLEncoder.encode(origin, "UTF-8").replaceAll("\\+", " ");
			}
			// Edge (userAgent에 "Edg"가 포함되어 있음)
			else if(userAgent.contains("Edg")) {
				origin = URLEncoder.encode(origin, "UTF-8");
			}
			// 나머지
			else {
				origin = new String(origin.getBytes("UTF-8"), "ISO-8859-1");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 다운로드 헤더 만들기
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Disposition", "attachment; filename=" + origin);
		header.add("Content-Length", file.length() + "");
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
		
	}
	
	@Override
	public ResponseEntity<Resource> downloadAll(String userAgent, int mailNo) {
		
		// /storage/temp 디렉터리에 임시 zip 파일을 만든 뒤 이를 다운로드 받을 수 있음
		// com.gdu.app14.batch.DeleteTempFiles에 의해서 /storage/temp 디렉터리의 임시 zip 파일은 주기적으로 삭제됨
		
		// 다운로드 할 첨부 파일들의 정보(경로, 이름)
		List<MailAtchDTO> attachList = mailMapper.selectMailAttachList(mailNo);
		
		// zip 파일을 만들기 위한 스트림
		FileOutputStream fout = null;
		ZipOutputStream zout = null;   // zip 파일 생성 스트림
		FileInputStream fin = null;
		
		// /storage/temp 디렉터리에 zip 파일 생성
		String tempPath = myFileUtil.getTempPath();
		
		File tempDir = new File(tempPath);
		if(tempDir.exists() == false) {
			tempDir.mkdirs();
		}
		
		// zip 파일명은 타임스탬프 값으로 생성
		String tempName =  System.currentTimeMillis() + ".zip";
		
		try {
			
			fout = new FileOutputStream(new File(tempDir, tempName));
			zout = new ZipOutputStream(fout);
			
			// 첨부가 있는지 확인
			if(attachList != null && attachList.isEmpty() == false) {

				// 첨부 파일 하나씩 순회
				for(MailAtchDTO attach : attachList) {
					
					// zip 파일에 첨부 파일 추가
					ZipEntry zipEntry = new ZipEntry(attach.getOriginName());
					zout.putNextEntry(zipEntry);
					
					fin = new FileInputStream(new File(attach.getMailPath(), attach.getChangeName()));
					byte[] buffer = new byte[1024];
					int length;
					while((length = fin.read(buffer)) != -1){
						zout.write(buffer, 0, length);
					}
					zout.closeEntry();
					fin.close();
					
				}
				
				zout.close();

			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		
		// 반환할 Resource
		File file = new File(tempDir, tempName);
		Resource resource = new FileSystemResource(file);
		
		// Resource가 없으면 종료 (다운로드할 파일이 없음)
		if(resource.exists() == false) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		// 다운로드 헤더 만들기
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Disposition", "attachment; filename=" + tempName);  // 다운로드할 zip파일명은 타임스탬프로 만든 이름을 그대로 사용
		header.add("Content-Length", file.length() + "");
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
		
	}
	
	@Override
	public List<MailAtchDTO> getMailAttach(int mailNo) {
		return mailMapper.selectMailAttachList(mailNo);
	}
	
	@Override
	public Map<String, Object> deleteReceiverData(List<String> mailNo, List<String> receiveType, HttpServletRequest request) {
		
		int empNo = ((EmpAddrDTO)request.getSession().getAttribute("mailUser")).getEmpNo();
		
		Map<String, Object> map = new HashMap<>();
		
		int updateResult = 0;
		
		for(int i = 0; i < mailNo.size(); i++) {
			
			map.put("empNo", empNo);
			map.put("mailNo", mailNo.get(i));
			map.put("receiveType", receiveType.get(i));
			
			updateResult += mailMapper.deleteReceiver(map);
			
			map.clear();

		}
		
		Map<String, Object> result = new HashMap<>();
		
		if(updateResult == mailNo.size()) {
			result.put("isDelete", true);
		} else {
			result.put("isDelete", false);
		}
		return result;
	}
	
}
