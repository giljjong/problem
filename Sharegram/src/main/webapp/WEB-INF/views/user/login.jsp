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

<style>
html {
  height: 100%;
}
body {
  margin:0;
  padding:0;
  font-family: sans-serif;
  background: linear-gradient(#141e30, #243b55);
}

.login-box {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 400px;
  padding: 40px;
  transform: translate(-50%, -50%);
  background: rgba(0,0,0,.5);
  box-sizing: border-box;
  box-shadow: 0 15px 25px rgba(0,0,0,.6);
  border-radius: 10px;
}

.login-box h2 {
  margin: 0 0 30px;
  padding: 0;
  color: #fff;
  text-align: center;
}

.login-box .user-idbox, 
.login-box .user-pwbox {
  position: relative;
}

.login-box .user-idbox input {
  width: 100%;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  margin-bottom: 30px;
  border: none;
  border-bottom: 1px solid #fff;
  outline: none;
  background: transparent;
}



.login-box .user-pwbox input {
  width: 100%;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  margin-bottom: 10px;
  border: none;
  border-bottom: 1px solid #fff;
  outline: none;
  background: transparent;  
  
}
.login-box .user-idbox label,
.login-box .user-pwbox label {
  position: absolute;
  top:0;
  left: 0;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  pointer-events: none;
  transition: .5s;
}

.login-box .user-idbox input:focus ~ label,
.login-box .user-pwbox input:focus ~ label,
.login-box .user-idbox input:valid ~ label, 
.login-box .user-pwbox input:valid ~ label {
  top: -20px;
  left: 0;
  color: #4673a3;
  font-size: 12px;
}

.login-box form a {
  position: relative;
  display: inline-block;
  color: #fff;
  font-size: 12px;
  margin-bottom: 30px;
  text-decoration: none;
  overflow: hidden;
  letter-spacing: 2px
}

.login-box a:hover {
  color: #4673a3;
  border-radius: 0px;
            
}

.login-box a span {
  position: absolute;
  display: block;
}


.loginbtn {
 background:#243b55;
     color:white;
     display:block;
     width:92.5%;
     max-width:680px;
     height:50px;
     border-radius:8px;
     margin:0 auto;
     border:none;
     cursor:pointer;
     font-size:14px;
     font-family: 'Montserrat', sans-serif;
     box-shadow:0 15px 30px rgba(#ffffff,.36);
    transition:.2s linear;
  
}

.loginbtn:hover {

background:#4673a3;

}





</style>
<script>
	
	$(function(){
		
		fn_login();
		$('.myPage').hide();
	});
	
	function fn_login(){
		
		$('#frm_login').submit(function(event){
			
			if($('#empNo').val() == '' || $('#empPw').val() == ''){
				alert('아이디와 비밀번호를 모두 입력하세요.');
				event.preventDefault();
				return;
			}
			
		});
		
	}
	
	
</script>
</head>
<body>

<div class="login-box">
  <h2>Login</h2>
  <form action="${contextPath}/user/login" method="post">
  	<input type="hidden" name="url" value="${url}">
  
    <div class="user-idbox">
      <input type="text" name="empNo" id="empNo" required="" autocomplete="off">
      <label>ID</label>
    </div>
    <div class="user-pwbox">
      <input type="password" name="empPw" id="empPw" required="" autocomplete="off">
      <label>Password</label>
    </div>
   
    <a href="${contextPath}/user/findPw">비밀번호 찾기</a>
    
    <div>			
	<button class="loginbtn">로그인</button>
	</div>
 
  </form>
  
</div>
</body>
</html>