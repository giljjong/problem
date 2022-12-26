<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- <jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include> --%>

<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.min.css">
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.min.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>


<script>
function getContextPath() {
	var begin = location.href.indexOf(location.origin) + location.origin.length;
	var end = location.href.indexOf("/", begin + 1);
	return location.href.substring(begin, end);
}
	
$(document).ready(function(){
	// 써머노트
	$('#boardContent').summernote({
		width: 800,
		height: 400,
		lang: 'ko-KR',
		toolbar: [
		    ['style', ['bold', 'italic', 'underline', 'clear']],
		    ['font', ['strikethrough', 'superscript', 'subscript']],
		    ['fontsize', ['fontsize']],
		    ['color', ['color']],
		    ['para', ['ul', 'ol', 'paragraph']],
		    ['height', ['height']],
		    ['insert', ['link', 'picture', 'video']]
		],
		callbacks: {
			onImageUpload: function(files){
				// 동시에 복수 이미지 업로드 가능
				for(let i = 0; i < files.length; i++) {
				var formData = new FormData();
				formData.append('file', files[i]);  
				}
				$.ajax({
					type: 'post',
					url: getContextPath() + '/board/uploadImage',
					data: formData,
					contentType: false, 
					processData: false,  
					dataType: 'json',    
					success: function(resData){
						console.log('-----');
						console.log(resData);
						$('#boardContent').summernote('insertImage', resData.src);
						
						$('#summernote_image_list').append($('<input type="hidden" name="summernoteImageNames" value="' + resData.filesystem + '">'))
					}
				}); // ajax
				} //for
			}  
		})  
	});
	
	
	$(function(){
		fn_fileCheck();
	});
	
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
	
	
	
	/* serviceImpl에서 처리
	$(document).ready(function(){
		$('#btn_add').click(function(){
			var form = $('#frm_upload')[0];
			console.log(form);
			 var formData = new FormData(form); 
		
			$.ajax({
				type : 'POST',
				url : '${contextPath}/board/upload/add',
				enctype: 'multipart/form-data',
				data : formData,
				processData : false,
				contentType : false,      
				success: function(resData){
					console.log(resData);
				 	alert('등록되었습니다.')	
				 	location.href= '${contextPath}/board/uploadList';
				},
				error: function(jqXHR){
					alert('등록이 실패했습니다.');
					history.back();
				}
			})
		}) 
	}) 
	*/
	
</script>

<style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css');
</style>

</head>
<body>
	
		<div id="uploadWrite">
			<h3>게시글 작성</h3>
			
			<form action="${contextPath}/board/upload/add" method="post" enctype="multipart/form-data">
					<input type="hidden" name="empNo" value="${ u.uploadEmpNo }" > <!--나중에 처리  -->
				<div>
					<label for="boardTitle">글제목</label>
					<input type="text" id="boardTitle" name="boardTitle" value="${ u.boardTitle }" required="required">
				</div>
				<br>
				<div>
					<label for="boardContent">내용</label>
					<textarea name="boardContent" name="filesystemList" id="boardContent"></textarea>		
				</div>
				
				<div>
					<label for="files">첨부</label>
					<input type="file" id="files" name="files" multiple="multiple">
					<div id="file_list"></div>
				</div>
				
				<div id="summernote_image_list"></div>
				
				<div>
					<button  id="btn_add">작성완료</button>
					<input type="reset" value="입력초기화" class="btn_primary">
					<input type="button" value="목록" onclick="location.href='${contextPath}/board/uploadList'">
				</div>
			
			</form>
	
		</div>
	
</body>
</html>