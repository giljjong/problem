<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>

		$(document).ready(function(){
		
		$('#content').summernote({
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
					var formData = new FormData();
					formData.append('file', files[0]);  // 파라미터 file, summernote 편집기에 추가된 이미지가 files[0]임
					$.ajax({
						type: 'post',
						url: getContextPath() + '/blog/uploadImage',
						data: formData,
						contentType: false,  // ajax 이미지 첨부용
						processData: false,  // ajax 이미지 첨부용
						dataType: 'json',    // HDD에 저장된 이미지의 경로를 json으로 받아옴
						success: function(resData){
							
							$('#content').summernote('insertImage', resData.src);
						}
					});  // ajax
				}  // onImageUpload
			}  // callbacks
		});
</script>
</head>
<body>
	<div>
		<span>메일쓰기</span>
		<br>
		
		<hr>
		
		<input type="button" value="보내기">&nbsp;&nbsp;&nbsp;
		<input type="button" value="임시저장">&nbsp;&nbsp;&nbsp;
		<input type="button" value="미리보기">&nbsp;&nbsp;&nbsp;
		<input type="button" value="내게쓰기">&nbsp;&nbsp;&nbsp;
		
		<hr>
		
		<input type="text" name="from" value="${mailUser.userName}" readonly><br>
		
		<label for="toName">받는사람</label>
		<input type="text" name="toName" id="toName"><br>
		
		<label for="cc">참조</label>
		<input type="text" name="cc" id="cc"><br>
		
		<label for="title">제목</label>
		<input type="text" name="title" id="title"><br>
		<div>
			<label for="content">내용</label>
			<textarea id="content" name="content"></textarea>
		</div>
		
	</div>
</body>
</html>