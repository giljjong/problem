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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css" integrity="sha512-MV7K8+y+gLIBoVD59lQIYicR65iaqukzvf/nwasF0nqhPay5w/9lJmVM2hMDcnK1OnMGCdVK+iQrJ7lzPJQd1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
	.mail_toolbar {
		display : flex;
	}
	.btn_group, .smart_toolbar {
		display : flex;
	}
</style>
</head>
<body>
	<div>
		<div>
			<ul class="smart_toolbar">
				<li><a href="${contextPath}/mail/listReceive">받은메일함</a></li>
				<li><a href="${contextPath}/mail/write">메일쓰기</a></li>
			</ul>
		</div>
		
		<hr>
		
		<div>
			<div>
				<div class="mail_toolbar">
					<div class="btn_group">
						<div><input type="checkbox" class="all_check"></div>
						<div><button class="btn_toggle">읽음</button></div>
						<div><button class="btn_toggle"><span class="text">삭제</span></button></div>
					</div>
					<div class="btn_group">
						<div><span class="snb_bar"></span></div>
						<div><button class="btn_toggle"><span class="text">답장</span></button></div>
						<div><button class="btn_toggle"><span class="text">전달</span></button></div>
					</div>
					<div class="btn_group">
						<div><span class="snb_bar"></span></div>
						<div><button class="btn_toggle"><span class="text">이동</span></button></div>
						<div><button class="btn_toggle"><span class="text">읽음표시</span></button></div>
						<div><button class="btn_toggle"><span class="text">주소록에추가</span></button></div>
					</div>
				</div>
			</div>
			<div>
				<table>
					<tbody>
						<c:forEach items="${mailList}" var="mail" varStatus="vs">
							<tr>
								<td> <input type="checkbox" class="check_mail" name="mailNo" value="${mail.mailNo}"> </td>
								<td>
									<i class="fa-regular fa-star"></i>
								</td>
								<td>
									<c:if test="${mail.readCheck eq 'N'}"><i class="fa-solid fa-envelope"></i></c:if>
									<c:if test="${mail.readCheck eq 'Y'}"><i class="fa-regular fa-envelope-open"></i></c:if>
								</td>
								<td> <c:if test="${mail.empName != null}">${mail.empName}</c:if> </td>
								<td>
									<c:if test="${mail.readCheck eq 'N'}">
										<strong><a href="${contextPath}/mail/receive/detail?mailNo=${mail.mailNo}">${mail.subject}</a></strong>
									</c:if>
									<c:if test="${mail.readCheck eq 'Y'}">
										<a href="${contextPath}/mail/receive/detail?mailNo=${mail.mailNo}">${mail.subject}</a>
									</c:if>
								</td>
								<td>${mail.receiveDate}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div>
					${paging}
				</div>
			</div>
		</div>
	</div>
</body>
</html>