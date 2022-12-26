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
	ul{
	   list-style:none;
	   padding-left:10px;
    }
    
    a {
    	text-decoration : none;
    }

	.mail_toolbar {
		display : flex;
	}
	.mail_list_tool {
		margin-left: auto;
	}
	.blind {
		display : none;
	}
	
	.attach_img {
		width : 38px;
		width : 45px;
		border-radius : 3px;
	}
	
	.file_name {
		padding-left : 10px;
	}
	
	.file_box {
		border : 1px solid lightgray;
		width : 700px;
	}
	
	.file_wrap a {
		text-decoration : none;
		color : #999;
	}
	
</style>
<script>
	
	function fn_goWrite(email) {
		
	  	var f = document.write_frm;
	
		f.setAttribute('method', 'post');
	  	f.setAttribute('action', '${contextPath}/mail/write/new');
	  
	  	f.email.value = email;
	
	  	f.submit();
	};
	
	function fn_goReply(action) {
		
	  	var f = document.write_frm;
	
		f.setAttribute('method', 'post');
	  	f.setAttribute('action', action);
	
	  	f.submit();
	};
	
	function fn_notReadChange(){
		$.ajax({
			type : 'post',
			url : '${contextPath}/mail/change/readCheck',
			data : 'mailNo[]=' + $('#mailNo').val() + '&readCheck[]=' + $('#readCheck').val(),
			dataType : 'json',
			success : function(resData) {
				if(resData.isResult){
					fn_getMailList();
				};
			}
		});	// ajax
		
	}
</script>
</head>
<body>
	<div>
		<div>
			<div><h3>보낸메일함</h3></div>
			<div class="cnt_info">
					<span class="info_text">전체메일</span> <span class="cnt_mail">${nReadCnt} / ${totalRecord}</span>
			</div>
			<div class="mail_toolbar">
				<div class="mail_cnt_tool">
					<a href="javascript:fn_goReply('${contextPath}/mail/write/reply')">답장</a>
					<a href="javascript:fn_goReply('${contextPath}/mail/write/delivery')">전달</a>
					<a href="#">삭제</a>
					<a href="#" onClick="fn_notReadChange();">안읽음</a>
				</div>
				<div class="mail_list_tool">
					<a href="${contextPath}/mail/folder/list">목록</a>
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
					<div class="cc_toggle_div blind">
						<span>참조</span>
						<c:forEach items="${addrList}" var="addr" >
							<c:if test="${addr.receiveType eq 'cc'}">
								<span class="cc_Span">${addr.name}&lt;${addr.email}&gt;</span>
							</c:if>
						</c:forEach>
					</div>
						<input type="hidden" name="receiveType" value="${receivData.receiveType}">
						<input type="hidden" name="readCheck" id="readCheck" value="${mail.readCheck}">
					<form name="write_frm" class="blind">
						<input type="hidden" name="email">
						<input type="hidden" name="mailNo" id="mailNo" value="${mail.mailNo}">
						<input type="hidden" name="deleteCheck" value="${receivData.deleteCheck}">
					</form>
					<span>${mail.receiveDate}</span>
					<div class="file_wrap">
						<div>
							<strong>첨부 ${attachCnt}개</strong>
							<a href="${contextPath}/mail/downloadAll?mailNo=${mail.mailNo}">모두 저장</a>
						</div>
						<div class="file_box">
							<ul>
								<c:forEach items="${attachList}" var="attach">
									<li class="img_line">
										<a href="${contextPath}/mail/download?fileNo=${attach.fileNo}">
											<c:if test="${attach.hasThumbnail == 1}">
													<img src="${contextPath}/mail/download?fileNo=${attach.fileNo}" class="attach_img" title="${attach.originName}">
											</c:if>
											<c:if test="${attach.hasThumbnail == 0}">
												<img src="${contextPath}/resources/images/attach.png" width="50px" class="attach_img" title="${attach.originName}">
											</c:if>
											<span class="file_name">${attach.originName}</span>
										</a>
									</li>
								</c:forEach>
							</ul>
						</div>
						<br><br>
						<div>
						</div>
					</div>
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