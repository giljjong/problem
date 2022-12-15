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
	<div>
		<table>
			<thead>
				<tr>
					<td>순번</td>
					<td>아이디</td>
					<td>포인트</td>
					<td>가입종류</td>
					<td>가입일</td>
					<td>휴면일</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="userList" var="user">
					<tr>
						<td>${user.userNo}</td>
						<td>${user.id}</td>
						<td>${user.point}</td>
						<td>${user.snsType}</td>
						<td>${user.createDate}</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="sleepUserList" var="sleepU">
					<tr>
						<td>${sleepU.userNo}</td>
						<td>${sleepU.id}</td>
						<td>${sleepU.point}</td>
						<td>${sleepU.snsType}</td>
						<td>${sleepU.createDate}</td>
						<td>${sleepU.sleepDate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>