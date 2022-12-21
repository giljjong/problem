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
	.blind {
		display : none;
	}
	.readChg, .detail_text {
		cursor : pointer;
	}
</style>
<script>
	$(function(){
		fn_getMailList();
		fn_readChange();
		fn_checkChoice();
		fn_readEvent();
		fn_checkAll();
		fn_checkOne();
	});
	
	function fn_getMailList(){
		$.ajax({
			type : 'get',
			url : '${contextPath}/get/trash',
			dataType : 'json',
			success : function(resData){
				$('.cnt_mail').empty();
				$('#mailBody').empty();
				
				$('.cnt_mail').text(resData.nReadCnt + ' / ' +resData.totalRecord);
				
				$.each(resData.mailList, function(i, mail){
				var tr = $('<tr>');
				tr
				.append($('<td>').html('<input type="checkbox" class="check_one lbl_one" name="mailNo" value="'+ mail.mailNo + '">'))
				.append($('<td class="blind">').html(mail.receiveType))
				.append($('<td>').html('<i class="fa-regular fa-star"></i>'))
				.append($('<td>').html('<input type="hidden" id="readCheck" class="blind" value="' + mail.readCheck +'">'))
				.append($('<td>').html($('<span class="readChg">').html(mail.readCheck == 'N' ? '<i class="fa-solid fa-envelope"></i>' : '<i class="fa-regular fa-envelope-open"></i>')))
				.append(mail.empName == null ? $('<td>').html(mail.sender) : $('<td>').html(mail.empName))
				.append($('<td>').html(mail.readCheck == 'N' ? '<a class="detail_text"><strong>' + mail.subject + '</strong></a>' : '<a class="detail_text">' + mail.subject + '</a>'))
				.append($('<td>').html(mail.receiveDate))
				.appendTo($('#mailBody'))
				
				})
			}
		});
	}
	
	function fn_readChange(){
		$(document).on('click', '.readChg', function(event){
			var mailNo = [$(this).parent().parent().children().first().children().first().val()];
			var readCheck = [$(this).parent().prev().children().first().val()];
			
			var objParams = {
					"mailNo"    : mailNo,
					"readCheck" : readCheck
	            };
			
			$.ajax({
				type : 'post',
				url : '${contextPath}/mail/change/readCheck',
				data : objParams,
				dataType : 'json',
				success : function(resData) {
					if(resData.isResult){
						fn_getMailList();
					};
				}
			});	// ajax
		}) // onClick
	} // fn
	
function fn_checkChoice(){
		
		var mailNo = new Array();
		var readCheck = new Array();
		$(document).on('click', '.check_one', function(event){
			if($(this).is(":checked")) {
				mailNo.push($(this).val());
				readCheck.push($(this).parent().next().next().next().children().first().val());
			} else if($(this).is(":checked") == false){
				for(var i = 0; i < mailNo.length; i++){
					if($(this).val() == mailNo[i]){
						mailNo.splice(i, 1);
						readCheck.splice(i, 1);
					}	//if
				}	// for
			} // else if
			console.log(objParams);
		}) // onClick
		
		var objParams = {
                "mailNo"      : mailNo,
                "readCheck"	  : readCheck,
                "receiveType" : "send"
        };
		
		$(document).on('click', '.btn_readChg', function(event){
			
			$.ajax({
				type : 'post',
				url : '${contextPath}/mail/change/readCheck',
				data : objParams,
				dataType : 'json',
				success : function(resData){
					if(resData.isResult){
						fn_getMailList();
					};
				}
			}); // ajax
		});	// onClick
		
		$(document).on('click', '.delete', function(event){
			$.ajax({
				type : 'post',
				url : '${contextPath}/remove/mail/trash',
				data : objParams,
				dataType : 'json',
				success : function(resData){
					fn_getMailList();
				}
			}); // ajax
		});	// onClick
	}
	
	function fn_readEvent(){
		$(document).on('click', '.detail_text', function(event){
			var mailNo = $(this).parent().parent().children().first().children().first().val()
			var receiveType = $(this).parent().prev().prev().prev().prev().prev().text();
			fn_readMail(mailNo, receiveType);
		});	// onClick
	}	// fn
	
	function fn_readMail(mailNo, receiveType){
		var f = document.write_frm;
		
		f.setAttribute('method', 'post');
	  	f.setAttribute('action', '${contextPath}/mail/receive/detail');
	  	
	  	f.mailNo.value = mailNo;
	  	f.receiveType.value = receiveType;
	
	  	f.submit();
	}
	
	function fn_checkAll(){
		$(document).on('click', '#check_all', function(event){
			$('.check_one').prop('checked', $(this).prop('checked'));
			$('.lbl_all, .lbl_one').toggleClass('lbl_checked');
		});
	};
	
	function fn_checkOne(){
		$(document).on('click', '.check_one', function(event){
			$(this).toggleClass('lbl_checked');
			let checkCount = 0;
			
			for(let i = 0; i < $('.check_one').length; i++) {
				checkCount += $($('.check_one')[i]).prop('checked');
			};
			
			$('#check_all').prop('checked', $('.check_one').length == checkCount);
			
			if($('#check_all').prop('checked')){
				$('.lbl_all').addClass('lbl_checked');
			} else {
				$('.lbl_all').removeClass('lbl_checked');
			}
		});
	};
</script>
</head>
<body>
	<div>
		<div>
			<ul class="smart_toolbar">
				<li><a href="${contextPath}/mail/folder/list">받은메일함</a></li>
				<li><a href="${contextPath}/mail/folder/send">보낸메일함</a></li>
				<li><a href="${contextPath}/mail/folder/trash">휴지통</a></li>
				<li><a href="${contextPath}/mail/write">메일쓰기</a></li>
			</ul>
		</div>
		
		<hr>
		
		<div>
			<div>
				<div class="cnt_info">
					<span class="info_text">전체메일</span> <span class="cnt_mail"></span>
				</div>
				<div class="mail_toolbar">
					<div class="btn_group">
						<div><input type="checkbox" id="check_all" class="lbl_all"></div>
						<div><button class="btn_toggle btn_readChg">읽음</button></div>
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
					<tbody id="mailBody">
					</tbody>
				</table>
				<div class="blind">
					<form name="write_frm">
						<input type="hidden" name="mailNo">
						<input type="hidden" name="deleteCheck" id="deleteCheck" value="Y">
						<input type="hidden" name="receiveType" id="receiveType">
						<input type="hidden" name="in" id="in" value="trash">
					</form>
				</div>
				<div>
					${paging}
				</div>
			</div>
		</div>
	</div>
</body>
</html>