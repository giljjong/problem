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
</head>
<body>
<script>
	$(document).ready(function(){
		// area1, area2 표시
		// 초기 상태 : area1, area2 둘 다 숨김
		$('#area1, #area2').css('display', 'none');
		// column 선택에 따른 area1, area2 표시
		$('#column').change(function() {     // #column == this
			let combo = $(this);
			if(combo.val() == '') {
				$('#area1, #area2').css('display', 'hidden');
			} else if(combo.val() == 'HIRE_DATE' || combo.val() == 'SALARY') {
				$('#area1').css('display', 'none');
				$('#area2').css('display', 'inline');
			} else {
				$('#area1').css('display', 'inline');
				$('#area2').css('display', 'none');
			}
		})
		
		// 자동 완성
		$('#email').keyup(function(){
			// db를 갔다 와야 함. 한 글자 입력하고 그 글자가 포함된 모든걸 자동완성 되려면. 따라서 ajax 처리!
			$('#auto_complete').empty();
			if($(this).val() == '') {
				return;
			}
			$.ajax({
				/* 요청 */
				type: 'get',
				url: '${contextPath}/emp/autoComplete',
				/* 응답 */
				data: 'target=' + $('#target').val() + '&param=' + $(this).val(), // 입력된 값 param=, this는 이벤트 대상! 따라서 #email. -> 입력된 이메일 값을 param으로 보내겠따
				dataType: 'json',
				success: function(resData) {
					if(resData.status == 200) {
					 //	$.each(배열, function(인덱스, 요소))  // 요소 이름은 내가 주고싶은걸로 주면 된다
						$.each(resData.list, function(i, emp){  // 요소 하나{}를 emp라고 부르겠다						 
					 		$('#auto_complete')
							.append($('<option>').val(emp.email));  // 만들고 싶은 태그를 jquery wrapper로 묶어서 적어주면 만들어준당~
													// list 배열에서 emp라는 요소의 email를 가져오겠다!
													// 자바스크립트 객체 문법으로는 emp["email"] 로 적는 것도 가능
						});
					}
				}
			})
		})
		
		
		$('#btn_all').click(function() {
			location.href = '${contextPath}/user/list';
		})
	})
</script>
</head>
<body>

	<div>
	<!-- 
		<selcet name="column">
		<input name="query">     -> 이 두개의 데이터가 DB로 전달 될 것
		
		 /emp/search로 보내는 파라미터 4개 = column, query, start, stop
	-->
		<form id="frm_search" action="${contextPath}/user/search">
			<select id="column" name="column">  <!-- submit할 때 넘어가는 값은 name값! -->
				<option value="">:::선택:::</option>   <!-- 칼럼이름을 value값으로 -->
				<!-- area1 : 완벽 일치해야 검색 -->
				<option value="EMPLOYEE_ID">사원번호</option>     
				<option value="E.DEPT_NO">부서번호</option> 
				 <!-- area1 : 일부만 일치해도 조회 가능 -->
				<option value="LAST_NAME">성</option>   	 
				<option value="FIRST_NAME">이름</option>
				<option value="PHONE_NUMBER">연락처</option> 
				 <!-- area2 : 날짜 및 숫자 검색 -->
				<option value="HIRE_DATE">입사일</option>
				<option value="SALARY">연봉</option>
			</select>
			<span id="area1">
				<input type="text" id="query" name="query">
			</span>
			<span id="area2">
				<input type="text" id="start" name="start">
				~
				<input type="text" id="stop" name="stop">
			</span>
			<span id="">
				<input type="submit" value="검색">
				<input type="button" value="전체사원 조회" id="btn_all">
			</span>
		</form>
		
		<!-- /emp/search로 보내는 파라미터 4개 = column, query, start, stop -->
	</div>

	<div>
		<select name="target" id="target">
			<option value="FIRST_NAME">이름</option>
			<option value="LAST_NAME">성</option>
			<option value="EMAIL">이메일</option>
		</select>
		<input type="text" id="email" name="email" list="auto_complete">
		<datalist id="auto_complete"></datalist>
		<!-- datalist 안에 option 태그 집어넣기를 위에서 jquery로! -->
	</div>
	
	<hr>

	<div>
		<table border="1">
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
				<c:forEach items="${emp}" var="emp" varStatus="vs">  <!-- varStatus : 0부터 시작하는 index 갖고 오는 방법! 변수vs에서 index 가져오기 -->
					<tr>
						<td>${beginNo - vs.index}</td>  <!-- 107, 106, 105 ... 순번 표시하기 -->
						<td>${emp.empNo}</td>
						<td>${emp.name}</td>
						<td>${emp.phone}</td>
						<td>${emp.departmentsDTO.deptName}</td>	
						<td>${emp.positionDTO.jobName}</td>	
						<td>${emp.joinDate}</td>
						<td>${emp.status}</td>		
						<td>${emp.salary}</td>		
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="10">
					${paging}
					
					
	
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
	
</body>
</html>