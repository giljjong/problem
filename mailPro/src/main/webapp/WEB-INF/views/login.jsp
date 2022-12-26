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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body>
	<div>
	<h1>로그인</h1>
		
		<form id="frm_login" action="${contextPath}/emp/login" method="post">
			
			<div>
				<label for="empNo">사원번호</label>
				<input type="text" name="empNo" id="empNo">
			</div>
			
			<div>
				<label for="empPw">비밀번호</label>
				<input type="password" name="empPw" id="empPw">
			</div>
			
			<div>			
				<button>로그인</button>
			</div>
			
			<div>
				<label for="rememberId">
					<input type="checkbox" id="rememberId">
					아이디 저장
				</label>
				<label for="keepLogin">
					<input type="checkbox" name="keepLogin" id="keepLogin">
					로그인 유지
				</label>
			</div>
		
		</form>
			
		<div>
			<a href="${contextPath}/emp/join/write">회원가입</a> | 
			<a href="${contextPath}/user/findPw">비밀번호 찾기</a>
		</div>
	</div>
</body>
</html>