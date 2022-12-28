<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

	<jsp:include page="../layout/header.jsp">
		<jsp:param value="${mail.subject}" name="title" />
	</jsp:include>
	
<link href="${contextPath}/resources/css/mailCss/mail_detail.css" rel="stylesheet" type="text/css">
	
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
	<div class="mail_body_wrap" style="padding-left:65px;">
		<div class="mail_body">
			<div>
				<span class="title_text">보낸메일함</span>
				<span class="info_text">전체메일</span> <span class="cnt_mail">${nReadCnt} / ${totalRecord}</span>
			</div>
			
			<hr>
			
			<div class="mail_toolbar">
				<div class="btn_wrap_content">
					<a href="javascript:fn_goReply('${contextPath}/mail/write/reply')" class="mail_btn">답장</a>
					<a href="javascript:fn_goReply('${contextPath}/mail/write/delivery')" class="mail_btn">전달</a>
					<a href="#" class="mail_btn">삭제</a>
					<a href="#" onClick="fn_notReadChange();" class="mail_btn">안읽음</a>
				</div>
				<div class="mail_list_tool">
					<a href="${contextPath}/mail/folder/list" class="hovertool list_text">목록</a>
					<a href="#" class="hovertool upDown_text">△</a>
					<a href="#" class="hovertool upDown_text">▽</a>
				</div>
			</div>
			<hr>
			<div>
				<div>
					<div class="mail_subject">
						<i class="fa-regular fa-star" style="font-size:16px;"></i>
						<span><strong>${mail.subject}</strong></span>
					</div>
					<div class="info_div">
						<span class="receive_info"><strong>보낸사람</strong></span> <a href="javascript:fn_goWrite('${mail.sender}')" class="mail_sender"><span>${mail.empName}&lt;${mail.sender}&gt;</span></a><br>
					</div>
					<div class="info_div">
						<span class="receive_info"><strong>받는사람</strong></span>
							<c:forEach items="${addrList}" var="addr" >
								<c:if test="${addr.receiveType eq 'To'}">
									<a href="javascript:fn_goWrite('${addr.email}')" class="mail_receiver"><span>${addr.name}&lt;${addr.email}&gt;</span></a>
								</c:if>
							</c:forEach>
					</div>
					<div class="cc_toggle_div blind info_div">
						<span class="receive_info"><strong>참조</strong></span>
						<c:forEach items="${addrList}" var="addr" >
							<c:if test="${addr.receiveType eq 'cc'}">
								<span class="cc_Span">${addr.name}&lt;${addr.email}&gt;</span>
							</c:if>
						</c:forEach>
					</div>
					<form name="write_frm" class="blind">
						<input type="hidden" name="receiveType" value="${receivData.receiveType}">
						<input type="hidden" name="readCheck" id="readCheck" value="${mail.readCheck}">
						<input type="hidden" name="email">
						<input type="hidden" name="mailNo" id="mailNo" value="${mail.mailNo}">
						<input type="hidden" name="deleteCheck" value="${receivData.deleteCheck}">
					</form>
					<span style="font-size:13px; color:#767678;">${mail.receiveDate}</span>
					<c:if test="${attachCnt != 0}">
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
					</c:if>
					<hr>
				</div>
				<div class="mail_content">
					${mail.mailContent}
				</div>
			</div>
		</div>
	</div>

<%@ include file="../layout/footer.jsp" %>