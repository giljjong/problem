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
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">
<style type="text/css">
	.blind {
		display: none;
	}
</style>
<script>

		$(function(){
			
			if('${mailNo}' != null && '${mailNo}' != 0) {
				$('#mailNo').val('${mailNo}');
			};
			
			if('${deleteCheck}' != null) {
				$('#deleteCheck').val('${deleteCheck}');
			};
		
		$('#mailContent').summernote({
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
							
							$('#mailContent').summernote('insertImage', resData.src);
						}
					});  // ajax
				}  // onImageUpload
			}  // callbacks
		});
		
		$('#btn_send').click(function(){
			$('#frm_send').submit();
		});
		
		fn_getMailInfo();
		
	})
	
	function fn_getMailInfo(){
			
		if($('#mailNo').val() != "") {
			$.ajax({
				type : 'post',
				url : '${contextPath}/mail/get/reply',
				data : 'mailNo=' + $('#mailNo').val() + '&deleteCheck=' + $('#deleteCheck').val() + '&receiveType=' + $('#receiveType').val(),
				dataType : 'json',
				success : function(resData) {
					
					var to = resData.mail.sender + ';';
					var cc = '';
					var userMail = '${mailUser.email}';
					
					var content = '<br>-----Original Message-----<br>From:"' + resData.mail.empName + '"&lt;' + resData.mail.sender + '&gt;<br>To: "' + '${mailUser.name}' + '"&lt;' + '${mailUser.email}' + '&gt;;';
					
					$.each(resData.addrList, function(i, addr){
						
						if(addr.receiveType == 'To'){
							if(addr.email != userMail){
								to += addr.email;
								to += '; ';
								content += '"' + addr.name + '"&lt;' + addr.email + '&gt;;';
							}
						}
						
					});
					
					content += '<br>Cc: ';
					
					$.each(resData.addrList, function(i, addr){
						if(addr.receiveType == 'cc') {
							cc += addr.email;
							cc += '; ';
							content += '"' + addr.name + '"&lt;' + addr.email + '&gt;;';
						};
					});
					
					content += '<br>Sent: ' + resData.mail.receiveDate + '<br>Subject: ' + resData.mail.subject + '<br>' + resData.mail.mailContent;
					
					if($('#type').val() == 'RE'){
						$('#strTo').val(to);
						$('#subject').val('RE: ' + resData.mail.subject);
					} else if($('#type').val() == 'FW') {
						$('#strTo').val('');
						$('#subject').val('FW: ' + resData.mail.subject);
					}
					$('#strCc').val(cc);
					$('#textArea').html(content);
				}
			});
		}
	}
</script>
</head>
<body>
	<div>
		<span>메일쓰기</span>
		<br>
		
		<hr>
		
		<input type="button" id="btn_send" value="보내기">&nbsp;&nbsp;&nbsp;
		<input type="button" value="임시저장">&nbsp;&nbsp;&nbsp;
		<input type="button" value="미리보기">&nbsp;&nbsp;&nbsp;
		<input type="button" value="내게쓰기">&nbsp;&nbsp;&nbsp;
		
		<hr>
		
		<form action="${contextPath}/mail/send" id="frm_send" method="post">
			<div class="blind">
				<input type="text" name="from" value="${mailUser.email}" readonly><br>
				<input type="text" id="mailNo" name="mailNo" value="0" readonly><br>
				<input type="hidden" id="type" name="type" value="${type}" readonly><br>
			</div>
			
			<label for="strTo">받는사람</label>
			<input type="text" name="strTo" id="strTo" value="${email}"><br>
			
			<label for="strCc">참조</label>
			<input type="text" name="strCc" id="strCc"><br>
			
			<label for="subject">제목</label>
			<input type="text" name="subject" id="subject"><br>
			<div>
				<label for="mailContent">내용</label>
				<textarea id="mailContent" name="mailContent"><span id="textArea"></span></textarea>
			</div>
		</form>
		<div class="blind">
			<input type="hidden" class="blind" id="deleteCheck" name="deleteCheck" value="${receivData.deleteCheck}">
			<input type="hidden" class="blind" id="receiveType" name="receiveType" value="${receivData.receiveType}">
		</div>
	</div>
</body>
</html>