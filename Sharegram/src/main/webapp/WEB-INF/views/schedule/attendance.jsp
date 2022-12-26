<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${contextPath}/resources/css/jquery-ui.min.css">
<link rel="stylesheet" href="${contextPath}/resources/css/datepicker.css">
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/jquery-ui.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">

<script>
$(function(){
	fn_checkAll();
	fn_checkOne();
	fn_add();
	fn_init(); 
	fn_list();
	fn_remove(); 
	fn_modify();
	fn_detail();
	fn_datepicker()
	/* fn_changePage();
	fn_PageUtil();
	*/
});




function fn_checkAll(){
	$('#check_all').click(function(){
		$('.check_one').prop('checked', $('#check_all').prop('checked'));
	});
}

function fn_checkOne(){
	$(document).on('click', '.check_one', function(){
		let checkCount = 0;
		for(let i = 0; i < $('.check_one').length; i++){
			checkCount += $($('.check_one')[i]).prop('checked');				
		}
		$('#check_all').prop('checked', checkCount == $('.check_one').length);
	});
}

function fn_add(){
	$('#btn_add').click(function(){
		// 추가할 회원 정보를 JSON으로 만든다.
		let member = JSON.stringify({
			'id': $('#id').val(),
			'name': $('#name').val(),
			'gender': $(':radio[name=gender]:checked').val(),
			'address': $('#address').val()
		});
		console.log( $('#name').val() )
		// 추가할 회원 정보를 DB로 보낸다.
		$.ajax({
			type: 'post',
			url: '${contextPath}/members',
			data: member,  // 파라미터 이름 없음(본문에 member를 포함시켜서 전송)
			contentType: 'application/json',  // 요청 데이터의 MIME-TYPE
			dataType: 'json',
			success: function(resData){
				console.log(resData)
				if(resData.insertResult > 0) {
					alert('회원이 등록되었습니다.');
					fn_list();
					fn_init();
				} else {
					alert('회원이 등록되지 않았습니다.');
				}
			},
			error: function(jqXHR){
				alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText);
			}
		});
	});
}

function fn_init(){
	$('#id').val('').prop('readonly', false);
	$('#name').val('');
	$(':radio[name=gender]').prop('checked', false);
	$('#address').val('');
}

// 전역변수
var page = 1;

function fn_list(){
	$.ajax({
		type: 'get',
		url: '${contextPath}/attendance' ,
		dataType: 'json',
		success: function(resData){
			console.log(resData)
			// 근태목록
			$('#attendace_list').empty();
			$.each(resData.attendanceList , function(i, list){
				let tr = '<tr>';
			   	tr += '<td><input type="checkbox" class="check_one" value="'+ list.attNo +'"></td>';   
				tr += '<td>' + list.empDTO.empNo + '</td>';  
				tr += '<td>' + list.empDTO.name + '</td>';
				tr += '<td>' + list.empDTO.depDTO.deptName + '</td>';
				tr += '<td>' + list.empDTO.posDTO.jobName + '</td>';
				tr += '<td>' + list.attStart + '</td>';
				tr += '<td>' + list.attEnd + '</td>';
				tr += '<td>' + list.attStatus + '</td>';
				$.each(resData.working , function(j, list){
					if(i === j)
					tr += '<td>' + list + '</td>'; 
				})
				
				$.each(resData.overWorking , function(K, list){
					if(i === K)
					tr += '<td>' + list + '</td>';
				}) 
				tr += '<td>' + list.earlyStatus + '</td>'; 
				tr += '<td><input type="button" value="조회" class="btn_detail" data-attendance_no="'+ list.attNo +'"></td>'; 
				$('#attendace_list').append(tr);
				
			});
			
			
		
		} 
	});
}

function fn_modify(){
	$('#btn_modify').click(function(){
		let attendance = JSON.stringify({
			attStart : $('#attStart').val(attendance.attStart),
			attEnd : $('#attEnd').val(attendance.attEnd),
		    attStatus : $('#attStatus').val(attendance.attStatus),
		});
		$.ajax({
			type: 'put',
			url: '${contextPath}/attendance',
			data: attendance,
			contentType: 'application/json',
			dataType: 'json',
			success: function(resData){
				console.log(resData)
				/* if(resData.updateResult > 0){
					alert('회원 정보가 수정되었습니다.');
					fn_list();
				} else {
					alert('회원 정보가 수정되지 않았습니다.');
				} */
			},
			error: function(jqXHR){
				alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText);
			}
		});
	});
}


function fn_changePage(){
	$(document).on('click', '.lnk_enable', function(){
		page = $(this).data('page');
		fn_list();
	});
}

function fn_detail(){
	$(document).on('click', '.btn_detail', function(){
		console.log('상세')
		$.ajax({
			type: 'get',
			url: '${contextPath}/attendance/' + $(this).data('attendance_no'),
			dataType: 'json',
			success: function(resData){
				let attendance = resData.attendance;
				if(attendance == null){
					alert('해당 회원을 찾을 수 없습니다.');
				} else {
					console.log(attendance);
					$('#empNo').val(attendance.empDTO.empNo);
					$('#name').val(attendance.empDTO.name);
					$('#attStart').val(attendance.attStart);
					$('#attEnd').val(attendance.attEnd);
					$('#attStatus').val(attendance.attStatus);
				} 
			}
		});
	});
}

function fn_remove(){
	console.log('삭제')
	$('#btn_remove').click(function(){
		if(confirm('선택한 회원을 모두 삭제할까요?')){
			// 삭제할 회원번호
			let attendacneNoList = '';
			for(let i = 0; i < $('.check_one').length; i++){
				if( $($('.check_one')[i]).is(':checked') ) {
					attendacneNoList += $($('.check_one')[i]).val() + ',';  // 3,1,  (마지막 콤마 있음을 주의)
				}
			}
			attendacneNoList = attendacneNoList.substr(0, attendacneNoList.length - 1);  // 3,1  (마지막 콤마 자르기)
			$.ajax({
				type: 'delete',
				url: '${contextPath}/attendance/' + attendacneNoList,
				dataType: 'json',
				success: function(resData){
					if(resData.deleteResult > 0){
						alert('선택된 회원 정보가 삭제되었습니다.');
						fn_list();
					} else {
						alert('선택된 회원 정보가 삭제되지 않았습니다.');
					}
				}
			});
		}
	});
}

function fn_datepicker(){
	$('#attStart').datepicker({
		dateFormat: 'yyyy년 MM월 dd일 HH시 mm분',  // 실제로는 yyyymmdd로 적용
			prevText: '이전 달',
			  nextText: '다음 달',
			  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
			  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
			  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			  showMonthAfterYear: true,
			  yearSuffix: '년'
	});
	$('#attEnd').datepicker({
		dateFormat: 'yy년 MM월 dd일 HH시 mm분',  // 실제로는 yyyymmdd로 적용
			prevText: '이전 달',
			  nextText: '다음 달',
			  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
			  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
			  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			  showMonthAfterYear: true,
			  yearSuffix: '년'
	});
}



</script>

</head>
<body>
	
	<h1>근태 페이지</h1>
	<div>
		<input type="hidden" id="attNo">
		<div>
			<label for="empNo">
				아이디 <input type="text" id="empNo" readonly>
			</label>
		</div>
		<div>
			<label for="name">
				이름 <input type="text" id="name" readonly>
			</label>
		</div>
		<div>
			<label for="attStart">
				출근시간 <input type="text" id="attStart">
			</label>
		</div>
		<div>
			<label for="attEnd">
				퇴근시간 <input type="text" id="attEnd">
			</label>
		</div>
		<div>
			<label for="attStatus">
				근무상태 <select id="attStatus">
					<option value="">선택</option>
					<option value="정상 출근">정상 출근</option>
					<option value="지각">지각</option>
					<option value="결근">결근</option>
					<option value="조퇴">조퇴</option>
				</select>
			</label>
					
		</div>
	</div>
	<div>
		<input type="button" value="초기화" onclick="fn_init()">
		<input type="button" value="등록하기" id="btn_add">
		<input type="button" value="수정하기" id="btn_modify">
	</div>
	<div>
		<input type="button" value="선택삭제" id="btn_remove">
		<table border="1">
			<thead>
				<tr>
					<td><input type="checkbox" id="check_all"></td> 
					<td>사원번호</td>
					<td>이름</td>
					<td>부서명</td>
					<td>직급명</td>
					<td>출근시간</td>
					<td>퇴근시간</td>
					<td>근무상태</td>
					<td>근무시간</td>
					<td>연장근무시간</td>
					<td>조퇴 여부</td>
				</tr>
			</thead>
			<tbody id="attendace_list"></tbody>
			<tfoot>
				<tr>
					<td colspan="11">
						<div id="paging"></div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
	
</body>
</html>