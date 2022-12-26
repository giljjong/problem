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
<style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css');
</style>
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
	
	.noticDetail {
		position: absolute;
		top: 50%;
		left: 50%;
		width: 800px;
		padding: 40px;
		transform: translate(-50%, -50%);
		background: rgba(0,0,0,.5);
		box-sizing: border-box;
		box-shadow: 0 15px 25px rgba(0,0,0,.6);
		border-radius: 10px;	
	}

	table {
	  	border-collapse: collapse;
	  	border-spacing: 0;
	}
	
	.noticDetail {
		/* padding: 60px 0; */
		background: #141e30;
	}
	
	.noticDetail {
		margin-bottom: 60px;
	}
	
	.noticDetail h3 {
		font-size: 20px;
	 	color: #FFFFFF;
	 	font-weight: 700;
	 	text-align: center;
	}
	
	.noticEdit_title {
		font-size: 16px;
	 	color: #FFFFFF;
	 	font-weight: 700;
	}
	
	.noticEdit_content {
		font-size: 16px;
	 	color: #FFFFFF;
	 	font-weight: 700;
	}
	
	.noticEdit_title_box {
		background: #FFFFFF;
		border-radius:8px;
		width: 720;
	 	height: 30;
	}
	
	.noticEdit_content_box{
		background: #FFFFFF;
		border-radius:8px;
		width: 720;
		height: 400;
	}
	
	.btn_primary {
		 background:#243b55;
	     color:white;
	     height:25px;	/* 버튼 높이(크기) 조정 */
	     border-radius:8px;
	     /* margin:0 auto; 버튼 가운데 정렬*/
	     margin-right: 5px;   /* 버튼 사이 간격 조정 */
	     border:none;
	     cursor:pointer;
	     font-size:14px;
	     font-weight: 600;
	     font-family: 'Montserrat', sans-serif;
	     box-shadow:0 15px 30px rgba(#ffffff,.36);
	     transition:.2s linear;
	}
	
	.btn_primary:hover {
		background:#4673a3;  /* RGB 70 115 163 */
	}
	
	.date {
		font-size: 13px;
	 	color: #FFFFFF;
	 	text-align: right;
	}
</style>

</head>
<body>

	<div class="noticDetail">
		<h3>전사공지 정보</h3>
			<form>
				<div class="noticEdit_title">
					<label for="boardTitle"><strong>제목</strong></label>
				</div>	<!-- cntr값 chk -->
					<div class="noticEdit_title_box">
						${ noticBoard.boardTitle }
					</div>
				<br>
				<div  class="noticEdit_content">
					<label for="boardContent"><strong>본문</strong></label>
				</div>
					<div class="noticEdit_content_box">
						${ noticBoard.boardContent }
					</div>
				<br>
				<div class="date">작성일 : ${ noticBoard.createDate }</div>
				<div class="date">수정일 : ${ noticBoard.modifyDate }</div>
			</form>
		<div>
			<form id="frm_notic" method="post">
				<input type="hidden" name="noticNo" value="${ noticBoard.noticNo }"><!-- onclick get 방식처리 됨으로 수정 -->
				<input type="button" value="게시글편집" onclick="location.href='${contextPath}/board/notic/edit'" class="btn_primary"> 			
				<input type="button" value="게시글삭제" onclick="location.href='${contextPath}/board/notic/remove'" class="btn_primary"> 			
				<input type="button" value="목록" onclick="location.href='${contextPath}/board/noticList'" class="btn_primary"> 			
			</form>
			
			<!-- <script>
				// 게시글 수정화면으로 이동
				$('#btn_edit').click(function(){
					$('#frm_notic').attr('action', '${contextPath}/board/notic/edit');
					$('#frm_notic').submit();
				});
				
				// 게시글 삭제
				$('#btn_remove').click(function(){
					if(confirm('게시글 삭제 후 복구는 불가능합니다. 삭제할까요?')){
						$('#frm_notic').attr('action', '${contextPath}/board/notic/remove');
						$('#frm_notic').submit();
						return;
					}
				});
			</script> -->
		</div>
	</div>
	
</body>
</html>