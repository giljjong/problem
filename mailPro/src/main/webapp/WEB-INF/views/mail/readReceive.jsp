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
	.mail_list_tool {
		margin-left: auto;
	}
</style>
<script >
	
	function fn_goWrite(email) {
		
	  	var f = document.write_frm;
	
		f.setAttribute('method', 'post');
	  	f.setAttribute('action', '${contextPath}/mail/write/new');
	  
	  	f.email.value = email;
	
	  	f.submit();
	};
	
	function fn_goReply(mailNo) {
		
	  	var f = document.write_frm;
	
		f.setAttribute('method', 'post');
	  	f.setAttribute('action', '${contextPath}/mail/write/reply');
	  	
	  	f.mailNo.value = mailNo;
	
	  	f.submit();
	};
</script>
</head>
<body>
	<div>
		<div>
			<div><h3>보낸메일함</h3></div>
			<div class="mail_toolbar">
				<div class="mail_cnt_tool">
					<a href="javascript:fn_goReply('${mail.mailNo}')">답장</a>
					<a href="#">전달</a>
					<a href="#">삭제</a>
					<a href="#">안읽음</a>
				</div>
				<div class="mail_list_tool">
					<a href="#">목록</a>
					<a href="#">△</a>
					<a href="#">▽</a>
				</div>
			</div>
			<hr>
			<div>
				<div>
					<i class="fa-regular fa-star"></i>
					<strong>${mail.subject}</strong><br>
					<span>보낸사람</span> <a href="javascript:fn_goWrite('${mail.sender}')"><span>${mail.empName}&lt;${mail.sender}&gt;</span></a><br>
					<span>받는사람</span>
						<c:forEach items="${addrList}" var="addr" >
							<c:if test="${addr.receiveType eq 'To'}">
								<a href="javascript:fn_goWrite('${addr.email}')"><span>${addr.name}&lt;${addr.email}&gt;</span></a>
							</c:if>
						</c:forEach>
					<br>
					<div class="cc_toggle_div">
						<span>참조</span>
						<c:forEach items="${addrList}" var="addr" >
							<c:if test="${addr.receiveType eq 'cc'}">
								<span class="cc_Span">${addr.name}&lt;${addr.email}&gt;</span>
							</c:if>
						</c:forEach>
					</div>
					<form name="write_frm">
						<input type="hidden" name="email">
						<input type="hidden" name="mailNo">
					</form>
					<span>${mail.receiveDate}</span>
					<hr>
				</div>
				<div>
					${mail.mailContent}
				</div>
			</div>
		</div>
	</div>
</body>
</html>