<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- <jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include> --%>
<style>
	.blind {
		display: none;
	}
</style>

<script>
	$(function(){
		fn_upload_list();
		fn_upload_edit();
		fn_swtichDownloadList();
		fn_editList();
		// fn_uploadRemove();
		fn_download();
		$('#attachList').hide();
		$('#allDownload').hide();
		fn_fileCheck();
		fn_removeAttach();
	})
	
	
	function fn_editList(){
		$.ajax({
			type : 'GET',
			url : '${contextPath}/board/upload/detail/ulist?uploadBoardNo=${uploadBoardNo}' ,
			dataType : 'json',
			success : function(resData){
				$('<ul>')
				 .append( $('<li>').text('사원번호 : ' + resData.u.uploadEmpNo) )
				 .append( $('<li>').text('제목 : ' + resData.u.uploadTitle) )
				 .append( $('<li>').text('내용 : ' + resData.u.uploadContent) )
				 .append( $('<li>').text('작성일 : ' + resData.u.createDate) )
				 .append( $('<li>').text('수정일 : ' + resData.u.modifyDate) )
				 .append( $('<li>').text('조회수 : ' + resData.u.hit) ) 
				 .appendTo('#uploadDetail'); 
				
				/* hidden처리 삭제예정 */
				if('${loginUser.empNo}' != resData.upload.empNo){
					$('#btn_upload_edit').hide();
					$('#btn_upload_remove').hide();
				} else {
					$('#btn_upload_edit').show();
					$('#btn_upload_remove').show();
				}
				if(resData.attachList.length == 0){
					$('#btn_download_list').hide();
				}
				
				 $.each(resData.attachList, function(i, attach){
					 $('<ul>')
					 .append( $('<li>').append( $('<a>').text(attach.origin).attr('href', '${contextPath}.board/upload/download?attachNo=' + attach.attachNo)   ) )
					 .appendTo('#attachList');
				 })
				 
					 $('<a>')
					 .text('전체 다운로드').attr('href', '${contextPath}/upload/downloadAll?uploadBoardNo=' + resData.upload.uploadBoardNo)
					 .appendTo('#allDownload'); 					
				  
			},
			error : function(jqXHR){
				alert('상세보기 실패');
			}
			
		}) 
	}
	
	// 업로드 게시글 삭제 (alert 변경 고려중)
	/* function fn_uploadRemove(){
		$('#btn_upload_remove').click(function(){
			if(confirm('첨부된 모든 자료가 삭제됩니다. 삭제하시겠습니까?')){
				$.ajax({
					type : 'POST',
					url : '${contextPath}/upload/remove',
					data : 'uploadBoardNo=' + ${uploadBoardNo} ,
					success : function (resData){
						alert('삭제가 성공했습니다.');
						location.href="${contextPath}/board/uploadList";
					}, 
					error : function (jqXHR){
						alert('삭제가 실패했습니다.');
						history.back();
					}
				})
			}
	   	}); 
	} 
	*/
	function fn_swtichDownloadList(){
		$('#btn_download_list').click(function(){
				$('#download_area').toggleClass('blind');				
		});
	}
	
	function fn_upload_edit(){
		$('#btn_upload_edit').click(function(){
			$('#frm_upload').attr('action', '${contextPath}/upload/edit?uploadBoardNo=${uploadBoardNo}');
			$('#frm_upload').submit();
		});
	}
	
	function fn_upload_list(){
		$('#btn_upload_list').click(function(){
			location.href='${contextPath}/board/uploadList';
		});
	}	
	
	function fn_fileCheck(){
			
		$('#files').change(function(){
			
			// 첨부 가능한 파일의 최대 크기
			let maxSize = 1024 * 1024 * 10;  // 10MB
			
			// 첨부된 파일 목록
			let files = this.files;
			
			// 첨부된 파일 순회
			$('#file_list').empty();
			$.each(files, function(i, file){
				
				// 크기 체크
				if(file.size > maxSize){
					alert('10MB 이하의 파일만 첨부할 수 있습니다.');
					$(this).val('');  // 첨부된 파일을 모두 없애줌
					return;
				}
				
				// 첨부 목록 표시
				$('#file_list').append('<div>' + file.name + '</div>');
				
			});
			
		});
	
	}
	
	function fn_removeAttach(){
		// 첨부 삭제
		$('.lnk_remove_attach').click(function(event){
			if(confirm('첨부한 파일을 삭제할까요?') == false){
				event.preventDefault();
				return;
			}
		});
	}
		
</script>
</head>
<body>
	
		<div id="uploadEdit">
			<h3>자료실 수정</h3>
			
			<form action="${contextPath}/board/upload/modify" method="post" enctype="multipart/form-data">
			
				<div>
					<button id="btn_edit">수정완료<i class="fa-regular fa-pen-to-square"></i></button>
					<input type="button" value="목록" onclick="location.href='${contextPath}/board/uploadList'">
				</div>
				
				<input type="hidden" name="uploadNo" value="${ u.uploadNo }">
				
				<div>
					<label for="uploadTitle">제목</label>
					<input type="text" id="uploadTitle" name="uploadTitle" value="${ u.uploadTitle }" required="required">
				</div>
				
				<div>
					<label for="uploadContent">내용</label>
					<input type="text" id="uploadContent" name="uploadContent" value="${ u.uploadContent }">
				</div>
				
				<div>
					<label for="files">첨부 추가</label>
					<input type="file" id="files" name="files" multiple="multiple">
					<div id="file_list"></div>
				</div>
			
			</form>
			
			<div>
				<h3>첨부삭제</h3>	
				<c:forEach items="${attachList}" var="attach">
					<div>
						${attach.origin}<a class="lnk_remove_attach" href="${contextPath}/board/upload/attach/remove?uploadNo=${ u.uploadNo }&attachNo=${attach.attachNo}"><i class="fa-regular fa-trash-can"></i></a>
					</div>
				</c:forEach>
			</div>
		</div>
	
</body>
</html>