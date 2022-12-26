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
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>

</head>
<header>
	<a href="${contextPath}/board/list">게시판</a>
	<a href="${contextPath}/mail/list">메일</a>
	<a href="${contextPath}/schedule/list">일정관리</a>
	<a href="${contextPath}/approval/list">전자결재</a>
</header>	
	
<body>
	<br>
	<div class="myPage">
		<c:if test="${loginEmp == null}">
			<a href="${contextPath}/user/login/form">로그인페이지</a><br>
		</c:if>
	
		<c:if test="${loginEmp != null}">
			<div id="login_info">
				${loginEmp.name}님의 보유 포인트
			<a href="${contextPath}/user/logout">로그아웃</a>
			</div>

		</c:if>
		
		<li><span class="snb_bar"></span><a href="${contextPath}/user/check/form" class="gnb_bar">마이페이지</a></li>
	</div>
	
	
	
	<table border="1" class="table table-striped-columns">
			<thead>
				<tr>
					<td>순번</td>
					<td>사원번호</td>
					<td>사원명</td>
					<td>전화번호</td>
					<td>부서명</td>
					<td>직위</td>
					<td>입사일자</td>
					<td>상태</td>
					<td>연봉</td>
					<!-- 부서명(departmentName) 때문에 조인이 필요함. 조인: pk와 조인 대상의 fk인 departmentId로 한다~ -->
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>순번</td>
					<td>사원번호</td>
					<td>사원명</td>
					<td>전화번호</td>
					<td>부서명</td>
					<td>직위</td>
					<td>입사일자</td>
					<td>상태</td>
					<td>연봉</td>
					<!-- 부서명(departmentName) 때문에 조인이 필요함. 조인: pk와 조인 대상의 fk인 departmentId로 한다~ -->
				</tr>

			</tbody>
			<tfoot>
				<tr>
					<td colspan="10">
					${paging}
					
					
	
					</td>
				</tr>
			</tfoot>
		</table>
		
		<div class="form-check form-switch">
  <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault">
  <label class="form-check-label" for="flexSwitchCheckDefault">Default switch checkbox input</label>
</div>
	
	
	
	
</body>
</html>