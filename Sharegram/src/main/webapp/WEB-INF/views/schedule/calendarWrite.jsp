<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script
	src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script
	src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet"
	href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">
<title>Insert title here</title>
<script>
	$(function() {
		fn_write();
	});
	function fn_write() {
		$('#btn_write').click(function() {
			let schedule = JSON.stringify({
				'scheduleTitle' : $('#title').val(),
				'scheduleStart' : $('#start').val(),
				'scheduleEnd' : $('#end').val(),
				'scheduleAllday' : $('#allday').val(),
			});
			$.ajax({
				type : 'post',
				url : '${contextPath}/schedule',
				data : schedule,
				contentType : 'application/json',
				
				dataType: 'json',
				success : function(resData) {
					if(resData.insertResult > 0 ){
						alert('일정이 등록되었습니다');
					/* 	$(opener.location).attr('href','javascript:fn_fullcalendar()');  */
					/* opener.parent.location.reload(); */
						window.close();
					} else {
						alert('일정이 등록되지 않았습니다');
					}
					
				},
				error : function(jqXHR) {
					alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText);
					window.close();
				}
			})

		});
	}
</script>
</head>
<body>
	<div>
		<input type="hidden" id="allday" value="${allday}">
		<h1>일정 입력</h1>
		<div>
			<label for="title">제목</label> <input type="text" id="title">
		</div>
		<div>
			<label for="start">시작일</label> <input type="text" id="start"
				value="${start}">
		</div>
		<div>
			<label for="end">종료일</label> <input type="text" id="end"
				value="${end}">
		</div>
		<button id="btn_write">일정 등록</button>
	</div>
</body>
</html>