package com.group.sharegram.board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.board.domain.AttachDTO;
import com.group.sharegram.board.domain.SummernoteImageDTO;
import com.group.sharegram.board.domain.UploadBoardDTO;

@Mapper
public interface UploadBoardMapper {
	public int selectAllUploadListCount();
	// public UploadBoardDTO selectBoardByNo(int uploadBoardNo);
	public List<UploadBoardDTO> selectUploadList(Map<String, Object> map);
	public int insertSummernoteImage(SummernoteImageDTO summernote);
	public int insertUpload(UploadBoardDTO upload);
	public int insertAttach(AttachDTO attach);
	
	public UploadBoardDTO selectUploadByNo(int uploadNo);
	
	public List<AttachDTO> selectAttachList(int uploadNo);
	// public int updateDownloadCnt(int attachNo);
	public AttachDTO selectAttachByNo(int attachNo);
	public int updateUpload(UploadBoardDTO upload);
	public int deleteAttach(int attachNo);
	public int deleteUpload(int uploadNo);
	public List<AttachDTO> selectAttachListInYesterday();
	
	public int updateHit(int uploadNo);
	
	public List<SummernoteImageDTO> selectSummernoteImageListInuploadBoard(int uploadNo);
	public List<SummernoteImageDTO> selectAllSummernoteImageList();
	
}
