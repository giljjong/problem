<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- <jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include> --%>
<style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css');
</style>

	<div class="anonyBoard">
		<div class="brd_thead">
			<div class="input_size">
				<h3>게시글 작성</h3>
				
				<form action="${contextPath}/board/anony/add" method="post" enctype="multipart/form-data">
					<div>
						<label for="anonyTitle"><strong>글제목</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="anonyTitle" placeholder="제목은 필수입니다." class="inputBox" size=17 required>
					</div>
					<br>
					<div class="inputFlex">
						<div>
							<label for="anonyContent"><strong>내용</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
						<div>
							<textarea rows="8" cols="30" name="anonyContent" placeholder="내용을 입력하세요." class="textBox" required>${a.anonyContent}</textarea>
						</div>
					</div>
					<div>
						<label for="empNo"><strong>작성자</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="empNo" value="${a.anonyEmpNo}" class="inputBox" size=24  required readonly>
					</div>
					<br>
					<div>
						<button class="btn_primary">작성완료</button>
						<input type="reset" value="입력초기화" class="btn_primary">
						<input type="button" value="목록" onclick="location.href='${contextPath}/board/anonyList'" class="btn_primary">
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>