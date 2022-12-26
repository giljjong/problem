<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

	<jsp:include page="../layout/header.jsp">
		<jsp:param value="메일쓰기" name="title" />
	</jsp:include>

<style>
	@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

	.upload_file {
	  margin: 0;
	  padding: 0;
	  box-sizing: border-box;
	  font-family: Pretendard, 'Malgun Gothic', sans-serif;
	}

	.upload_file {
	  width: 50vw;
	  height: 10vh;
	   
	  margin: .6rem;
	  overflow: auto;
	  
	  display: flex;
	  justify-content: center;
	  align-items: center;
	
	  border-radius: 5px;
	  border: 4px dashed #ddd;
	  user-select: none;
	  transition: 0.4s;
	}
	
	.btn_wrap{
		display : flex;
	}
	
	.attach_btn {
		display : inline-block;
		width : 58px;
		height : 24px;
		font-size : 16px;
		font-weight : 400;
		border : 1.7px solid darkgray;
		border-radius : 5px;
		text-align : center;
	}
	
	.attach_btn:hover {
		cursor : pointer;
	}

	/* 드롭 반응 */
	.upload_file.active {
	  background: #ddd;
	}
	
	.blind {
		display: none;
	}
	
	.addfile_msg, .addfile_list {
		font-size : 1.2rem;
	}
	
	.addfile_list {
		padding-left : 14px;
	}
	
	
	.delete i{
	    color: #ff5353;
	    margin-left: 5px;
	}
	.filebox {
		padding-top : -16px;
	}
	
</style>
<script>

		$(function(){
			
			if('${mailNo}' != null && '${mailNo}' != 0) {
				$('#mailNo').val('${mailNo}');
			};
			
			if('${deleteCheck}' != null) {
				$('#deleteCheck').val('${deleteCheck}');
			};
		
		$('#mailContent').summernote({
			width: 1200,
			height: 700,
			lang: 'ko-KR',
			toolbar: [
			    ['style', ['bold', 'italic', 'underline', 'clear']],
			    ['font', ['strikethrough', 'superscript', 'subscript']],
			    ['fontsize', ['fontsize']],
			    ['color', ['color']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['insert', ['link', 'picture', 'video']]
			],
			callbacks: {
				onImageUpload: function(files){
					for(let i = 0; i < files.length; i++) {
						var formData = new FormData();
						formData.append('file', files[i]);  // 파라미터 file, summernote 편집기에 추가된 이미지가 files[0]임
						$.ajax({
							type: 'post',
							url: '${contextPath}/mail/summernote/uploadImage',
							data: formData,
							contentType: false,  // ajax 이미지 첨부용
							processData: false,  // ajax 이미지 첨부용
							dataType: 'json',    // HDD에 저장된 이미지의 경로를 json으로 받아옴
							success: function(resData){
								
								$('#mailContent').summernote('insertImage', resData.src);
								$('#summernote_image_list').append($('<input type="hidden" name="summernoteImageNames" value="' + resData.filesystem + '">'))
							}
						});  // ajax
					}	// for
				}  // onImageUpload
			}  // callbacks
		});
		
		fn_getMailInfo();
		fn_fileCheck();
		fn_submit();
		fn_getAttachInArray();
		fn_sendToToggle();
		
		if($('#attachCnt').val() != ""){
			$('.upload_file').css('justify-content', 'left');
		 	$('.addfile_list').removeClass('blind');
            $('.addfile_msg').addClass('blind');
		}
	})
	
	function fn_getMailInfo(){
			
		if($('#mailNo').val() != 0) {
			
			$.ajax({
				type : 'post',
				url : '${contextPath}/mail/get/reply',
				data : 'mailNo=' + $('#mailNo').val() +'&deleteCheck=' + $('#deleteCheck').val() + '&receiveType=' + $('#receiveType').val(),
				dataType : 'json',
				success : function(resData) {
					
					var to = resData.mail.sender + ';';
					var cc = '';
					var userMail = '${mailUser.email}';
					
					var content = '<br>-----Original Message-----<br>From:"' + resData.mail.empName + '"&lt;' + resData.mail.sender + '&gt;<br>To: "' + '${mailUser.name}' + '"&lt;' + '${mailUser.email}' + '&gt;;';
					
					$.each(resData.addrList, function(i, addr){
						
						if(addr.receiveType == 'To'){
							if(addr.email != userMail){
								to += addr.email;
								to += '; ';
								content += '"' + addr.name + '"&lt;' + addr.email + '&gt;;';
							}
						}
						
					});
					
					content += '<br>Cc: ';
					
					$.each(resData.addrList, function(i, addr){
						if(addr.receiveType == 'cc') {
							cc += addr.email;
							cc += '; ';
							content += '"' + addr.name + '"&lt;' + addr.email + '&gt;;';
						};
					});
					
					content += '<br>Sent: ' + resData.mail.receiveDate + '<br>Subject: ' + resData.mail.subject + '<br>' + resData.mail.mailContent;
					
					if($('#type').val() == 'RE'){
						$('#strTo').val(to);
						$('#subject').val('RE: ' + resData.mail.subject);
					} else if($('#type').val() == 'FW') {
						$('#strTo').val('');
						$('#subject').val('FW: ' + resData.mail.subject);
					}
					$('#strCc').val(cc);
					$('#textArea').html(content);
				}
			});
		}
	}
		
	function fn_sendToToggle(){
		
		$('#sendMe').show();
		$('#sendOther').hide();
		$('#btn_toMe').hide();
		
		$(document).on('click', '#sendMe', function(event){
			$('#sendMe').hide();
			$('#sendOther').show();
			$('#btn_toMe').show();
			$('.from_box').hide();
			$('.cc_box').hide();
			$('#strTo').val($('#from').val());
		});
		
		$(document).on('click', '#sendOther', function(event){
			$('#sendMe').show();
			$('#sendOther').hide();
			$('#btn_toMe').hide();
			$('#strTo').val('');
			$('.from_box').show();
			$('.cc_box').show();
		});
	}
		
</script>
</head>
<body>
	<div>
		<span>메일쓰기</span>
		<br>
		
		<hr>
		
		<div class="btn_wrap">
			<div class="from_box">
				<input type="button" class="btn_send" value="보내기">&nbsp;&nbsp;&nbsp;
				<input type="button" value="임시저장">&nbsp;&nbsp;&nbsp;
				<input type="button" value="미리보기">
			</div>
			<div>
				<input type="button" class="btn_send" id="btn_toMe" value="저장">&nbsp;&nbsp;&nbsp;
				<input type="button" id="sendMe" value="내게쓰기">
				<input type="button" id="sendOther" value="메일쓰기">
			</div>
		</div>
		
		<hr>
		
		<form id="frm_send" method="post" enctype="multipart/form-data">
			<div class="blind">
				<input type="text" name="from" id="from" value="${mailUser.email}" readonly><br>
				<input type="text" id="mailNo" name="mailNo" value="0" readonly><br>
				<input type="hidden" id="type" name="type" value="${type}" readonly><br>
			</div>
			
			<div class="from_box">
				<label for="strTo">받는사람</label>
				<input type="text" name="strTo" id="strTo" value="${email}"><br>
			</div>
			
			<div class="cc_box">
				<label for="strCc">참조</label>
				<input type="text" name="strCc" id="strCc"><br>
			</div>
			
			<label for="subject">제목</label>
			<input type="text" name="subject" id="subject"><br>
			
			<div class="insert">
		    	<label for="files"><span class="attach_btn">내 PC</span></label>
				<input type="file" id="files" class="blind" name="files" onchange="addFile(this);" multiple>	
		        <div id="file_list"></div>
			</div>
			<div class="upload_file" draggable="true">
				<div class="addfile_msg">파일을 마우스로 끌어오세요.</div>
				<div class="addfile_list blind">
					<c:if test="${attachCnt != 0}">
						<c:forEach items="${attachList}" var="attach" varStatus="vs">
						<!-- varstatus 만들기 -->
							<div id="fileNo${vs.index}" class="filebox">
								<span class="blind" id="get_attach${vs.index}">${attach.fileNo}</span>
					            <span class="name">${attach.originName}</span>
					            <a class="delete" onclick="fn_exceptFile('${vs.index}');"><i class="far fa-minus-square"></i></a>
					         </div>
						</c:forEach>
					</c:if>
				</div>
			</div>
			
			<script>
				var fileNo = 0;
				var filesArr = new Array();
				var filNoArr = new Array();
				
				function fn_getAttachInArray(){
					if($('#attachCnt').val() != null) {
						for(let i = 0; i < attachCnt; i++){
							filNoArr.push($('#get_attach' + i).text());
						}
					}
				}
				
				function fn_fileCheck(){
					
					const $drop = document.querySelector(".upload_file");
					const $title = document.querySelector(".upload_file .addfile_list");
					
					// 드래그한 파일 객체가 해당 영역에 놓였을 때
					$drop.ondrop = (e) => {
					  e.preventDefault();
					  $drop.className = "upload_file";
					  const files = [...e.dataTransfer?.files];
					  addFile(files);
					}
	
					// ondragover 이벤트가 없으면 onDrop 이벤트가 실핻되지 않습니다.
					$drop.ondragover = (e) => {
					  e.preventDefault();
					}
	
					// 드래그한 파일이 최초로 진입했을 때
					$drop.ondragenter = (e) => {
					  e.preventDefault();
					 
					  $drop.classList.add("active");
					}
	
					// 드래그한 파일이 영역을 벗어났을 때
					$drop.ondragleave = (e) => {
					  e.preventDefault();
					  
					  $drop.classList.remove("active");
					}
				};
	
				/* 첨부파일 추가 */
				function addFile(obj){
				    var maxFileCnt = 10 - $('#attachCnt');   // 첨부파일 최대 개수
				    var attFileCnt = document.querySelectorAll('.filebox').length;    // 기존 추가된 첨부파일 개수
				    var remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
				    
					if(obj.length > 0){
						var curFileCnt = obj.length;
						var object = obj;
					} else {
						var curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수
						var object = obj.files;
					}

				    // 첨부파일 개수 확인
				    if (curFileCnt > remainFileCnt) {
				        alert("첨부파일은 최대 " + maxFileCnt + "개 까지 첨부 가능합니다.");
				    } else {
				        for (const file of object) {
				            // 첨부파일 검증
				            if (validation(file)) {
				                // 파일 배열에 담기
				                var reader = new FileReader();
				                reader.onload = function () {
				                    filesArr.push(file);
				                };
				                reader.readAsDataURL(file);
	
				                // 목록 추가
				                let htmlData = '';
				                htmlData += '<div id="file' + fileNo + '" class="filebox">';
				                htmlData += '<span class="name">' + file.name + '</span>';
				                htmlData += '<a class="delete" onclick="fn_deleteFile(' + fileNo + ');"><i class="far fa-minus-square"></i></a>';
				                htmlData += '</div>';
				                $('.addfile_list').append(htmlData);
				                $('.upload_file').css('justify-content', 'left');
				                $('.addfile_list').removeClass('blind');
				                $('.addfile_msg').addClass('blind');
				                fileNo++;
				            } else {
				                continue;
				            }
				        }
				    }
				    // 초기화
				    document.querySelector("input[type=file]").value = "";
				}
	
				/* 첨부파일 검증 */
				function validation(obj){
				    if (obj.name.length > 100) {
				        alert("파일명이 100자 이상인 파일은 제외되었습니다.");
				        return false;
				    } else if (obj.size > (20 * 1024 * 1024)) {
				        alert("최대 파일 용량인 20MB를 초과한 파일은 제외되었습니다.");
				        return false;
				    } else if (obj.name.lastIndexOf('.') == -1) {
				        alert("확장자가 없는 파일은 제외되었습니다.");
				        return false;
				    } else {
				        return true;
				    }
				}
	
				/* 첨부파일 삭제 */
				function fn_deleteFile(num) {
				    document.querySelector("#file" + num).remove();
				    filesArr[num].is_delete = true;
				}
				
				function fn_exceptFile(num){
					document.querySelector("#fileNo" + num).remove();
					filNoArr.splice(num, 1);
				}
				
				function fn_submit(){
					$('.btn_send').click(function(){
						
						var form = document.querySelector("form");
					    var formData = new FormData(form);
					    
					    for(let i = 0; i < filNoArr.length; i++){
						    formData.append("fileNo", filNoArr[i]);
					    };
					    
					    for(let i = 0; i < filesArr.length; i++) {
					        // 삭제되지 않은 파일만 폼데이터에 담기
					        if (!filesArr[i].is_delete) {
					            formData.append("attachs", filesArr[i]);
					        }
					    };
					    
					    $.ajax({
					    	type : 'post',
					    	url : '${contextPath}/mail/send',
					    	dataType : 'json',
					    	data: formData,
					    	processData : false,
					    	contentType : false,
					    	success : function(resData){
					    		if(resData == 200) {
					    			location.href='${contextPath}/mail/sendSuccess';
					    		} else {
					    			// alert('메일 전송이 실패했습니다.');
					    			location.href='${contextPath}/mail/sendSuccess';
					    		}
					    	}
					    });	// ajaxz
						
						
					});	// click
				}	// fn
				
			</script>
			
			<div>
				<label for="mailContent">내용</label>
				<textarea id="mailContent" name="mailContent"><div id="textArea"></div></textarea>
			</div>
			<div id="summernote_image_list"></div>
		</form>
		<div class="blind">
			<input type="hidden" class="blind" id="deleteCheck" name="deleteCheck" value="${receivData.deleteCheck}">
			<input type="hidden" class="blind" id="receiveType" name="receiveType" value="${receivData.receiveType}">
			<input type="hidden" id="attachCnt" value="${attachCnt}">
		</div>
	</div>

	<%@ include file="../layout/footer.jsp" %>