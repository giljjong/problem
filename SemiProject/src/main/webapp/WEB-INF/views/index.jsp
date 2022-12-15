<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>

   <h1>로그인</h1>
   <div>
      <form id="frm_login" action="${contextPath}/user/login" method="post">
      
         <input type="hidden" name="url" value="${url}">
         
         <div>
            <label for="id">아이디</label>
            <input type="text" id="id" name="id">
         </div>
         <div>
            <label for="pw">비밀번호</label>      
            <input type="password" id="pw" name="pw">
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
               <input type="checkbox" name="keepLogin" value="keep" id="keepLogin">
               로그인 유지
            </label>
         </div>
      </form>
      
      <div>
         <a href="${contextPath}/user/agree">회원가입</a> | 
         <a href="${contextPath}/user/findId">아이디 찾기</a> | 
         <a href="${contextPath}/user/findPw">비밀번호 찾기</a>
      </div>
      
   </div>
   
   <a href="free/list">자유게시판 가기</a><br>
   <a href="gallery/list">갤러리게시판 가기</a><br>
   <a href="upload/list">업로드게시판 가기</a><br>
   <a href="admin/user/list">관리자 페이지 가기</a>
</body>
</html>