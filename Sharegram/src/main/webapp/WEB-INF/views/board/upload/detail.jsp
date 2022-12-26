<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- <jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include> --%>
<style>
	.blind {
		display: none;
	}
</style>

<script>
	$(function(){
		
		// 게시글 수정화면으로 이동
		$('#btn_upload_edit').click(function(event){
			$('#frm_upload').attr('action', '${contextPath}/board/upload/edit');
			$('#frm_upload').submit();
		});
		
		// 게시글 삭제
		$('#btn_upload_remove').click(function(event){
			if(confirm('첨부된 모든 파일이 함께 삭제됩니다. 삭제할까요?')){
				$('#frm_upload').attr('action', '${contextPath}/board/upload/remove');
				$('#frm_upload').submit();
			}
		});
		
		// 게시글 목록
		$('#btn_upload_list').click(function(event){
			location.href = '${contextPath}/board/uploadList';
		});
		
		// 첨부 이미지에 툴팁 적용
		// 태그의 title 속성 값이 툴팁으로 나타남
		$('.attach_img').tooltip();
		
	});
		
</script>
</head>
<body>

	<div>
		<h3>자료실 게시글 정보</h3>
		<ul>
			<li>제목 : ${ u.boardTitle }</li>
			<li>내용 : ${ u.boardContent }</li>
			<li>작성일 : ${ u.createDate }</li>
			<li>수정일 : ${ u.modifyDate }</li>
		</ul>
		<div>
			<form id="frm_upload" method="post">
				<input type="hidden" name="uploadNo" value="${ u.uploadNo }">
				<input type="button" value="게시글편집" id="btn_upload_edit"> 			
				<input type="button" value="게시글삭제" id="btn_upload_remove"> 			
				<input type="button" value="게시글목록" id="btn_upload_list"> 			
			</form>
		</div>
	</div>
	
	<hr>
	
	<div>
		<h3>첨부자료 목록 및 다운로드</h3>
		<div>
			<c:forEach items="${attachList}" var="attach">
				<a href="${contextPath}/board/upload/download?attachNo=${ a.attachNo }">
					<c:if test="${a.hasThumbnail == 1}">
						<img src="${contextPath}/board/upload/display?attachNo=${a.attachNo}" class="attach_files" title="${attach.origin}">
					</c:if>
					<c:if test="${attach.hasThumbnail == 0}">
						<img src="${contextPath}/resources/images/attach.png" width="50px" class="attach_files" title="${attach.origin}">
					</c:if>
				</a>
			</c:forEach>
		</div>
		<br><br>
		<div>
			<a href="${contextPath}/board/upload/downloadAll?uploadNo=${ u.uploadNo }">일괄 다운로드</a>
		</div>
	</div>
</body>
</html>