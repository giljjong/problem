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
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">
</head>
<body>
<script>
	
	$(function(){
		
		$('#btn_check_pw').click(function(){
			
			$.ajax({
				
				type: 'post',
				url: '${contextPath}/user/check/pw',
				data: 'empPw=' + $('#empPw').val(),
				dataType: 'json',
				success: function(resData){
					if(resData.isEmp){
						location.href = '${contextPath}/user/mypage';
					} else {
						alert('비밀번호를 확인하세요.');
					}
				}
			});
		});
	});
	
</script>
</head>
<body>

	<div>
		<div>비밀번호를 다시 한 번 입력해주세요</div>
		<div>
			<label for="empPw">비밀번호</label>
			<input type="password" id="empPw">
		</div>
		<div>
			<input type="button" value="확인" id="btn_check_pw">
			<input type="button" value="취소" onclick="history.back()">
		</div>
	</div>

</body>
</html>