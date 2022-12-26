<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>
	
	<div>
		<h1>회원 가입</h1>
		
		<hr>
		
		<form id="frm_join" action="${contextPath}/emp/join" method="post">
			<div>
				<label for="name">이름</label>
				<input type="text" name="name" id="name">
			</div>
			<div>
				<label for="empPw">패스워드</label>
				<input type="password" name="empPw" id="empPw">
			</div>
			<div>
				<label for="birthday">생년월일</label>
				<input type="text" name="birthday" id="birthday">
			</div>
			<div>
				<label for="deptName">부서명</label>
				<input type="text" name="deptName" id="deptName">
			</div>
			<div>
				<label for="jobName">직책이름</label>
				<input type="text" name="jobName" id="jobName">
			</div>
			
			<hr>
			
			<div>
				<button>가입하기</button>
				<input type="button" value="취소하기" onclick="location.href='/'">
			</div>
		</form>
	</div>
	
</body>
</html>