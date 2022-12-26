<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.min.js"></script>

<script src='${contextPath}/resources/bootstrap-5.2.2-dist/js/bootstrap.bundle.min.js'></script> 


<script
	src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script
	src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet"
	href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">

<link rel='stylesheet'
	href="${contextPath}/resources/fullcalendar/lib/main.css" />
<link rel='stylesheet'
	href="${contextPath}/resources/css/fullcalendar.css">	
	
<script src="${contextPath}/resources/fullcalendar/lib/main.js"></script>
<script src='${contextPath}/resources/fullcalendar/lib/locales-all.js'></script>


<style>
.blind {
		display: none;
	}

</style>
<script>

	$(function () {
		fn_fullcalendar();
		fn_write();
	});
	
	
	
	function fn_fullcalendar(){
		var calendarEl = document.getElementById('calendar');
		  var calendar = new FullCalendar.Calendar(calendarEl, {
		    googleCalendarApiKey: 'AIzaSyCwPYapKCl7z89E7azAvNTr4IsfP4uo4YQ',
		    initialView: 'dayGridMonth',
		    firstDay: 1, //월요일부터 달력시작
		    locale: 'ko',
		    selectable: true, // 사용자가 클릭하고 드래그하여 여러 날짜 또는 시간 슬롯을 강조 표시할 수 있습니다.
		    expandRows: true, // 화면에 맞게 높이 재설정
		    nowIndicator: true, // 지금 시간 빨간색으로 마크
		    businessHours: true,
		    editable: true,
		    navLinks: true,
		    dayMaxEvents: true,
		    displayEventTime: true,
		    displayEventEnd:  true,
		    
		    height: 900,
		    weight: 400,
		    aspectRatio: 0.01,
		    
		    /* eventAdd: function (obj) {
		      // 이벤트가 추가되면 발생하는 이벤트
		      console.log(obj);
		      console.log(obj.event.startStr);
		    },
		    eventChange: function (obj) {
		      // 이벤트가 수정되면 발생하는 이벤트
		      console.log(obj);
		    },
		    eventRemove: function (obj) {
		      // 이벤트가 삭제되면 발생하는 이벤트
		      console.log(obj);
		    }, */
		   
		   /*  eventTimeFormat : {
		        year: 'numeric',
		    	month: '2-digit',
		        day: '2-digit',
		        weekday: 'long',
		        hour : '2-digit',
		        minute : '2-digit',
		    }, */
		    
		   /*  eventTimeFormat : 'yyyy-MM-dd a HH:mm', */
		 	/* titleFormat: 'dddd, MMMM D, YYYY', */
		    //헤더
		    headerToolbar: {
		      start: 'title',
		      center: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek',
		      end: 'today prevYear,prev,next,nextYear',
		    },
		    
		    footerToolbar: {
		    	start :  'attendance leave write',
		    },
	
		    //업무시간
		    businessHours: {
		      daysOfWeek: [1, 2, 3, 4, 5],
		      startTime: '09:00',
		      endTime: '18:00',
		    },
	
		 
	
		   
		    navLinkDayClick: function (date, jsEvent) {
		      console.log('day', date.toISOString());
		      console.log('coords', jsEvent.pageX, jsEvent.pageY);
		    },
		    
		    eventSources: [
			      {
			        googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
			        className: '대한민국 공유일',
			        color: 'red',
			      },
			],
	
			// 나중에 지우고
		    /*  events: [
		      // 일정 데이터 추가 , DB의 event를 가져오려면 JSON 형식으로 변환해 events에 넣어주면된다.
		        {
		        title: '일정',
		        start: '2022-12-13',
		        end: '2022-12-17',
		        backgroundColor : 'Brown',
		        textColor : 'red',
		      }, 
		    ],  */
		    
		    //리스트 반환
		   
		    events : function(fetchInfo, successCallback, failureCallback) {
		    	 $.ajax({
		    		type:"get",
		    		url:"${contextPath}/schedule",
		    		dataType:"json",
		    		success : function(resData){
		    			let events = [];
		    			$.each(resData ,function (index, data){
		    				events.push({
		    					extendedProps: {
		    						scheduleNo : data.scheduleNo,
		    					},
		    					title : data.scheduleTitle,
		    					start : moment(data.scheduleStart).format(),
		    					end	  : moment(data.scheduleEnd).format(),
		    					allDay : data.scheduleAllday,
		    				})
		    						
		    			})
                  
		    			console.log('---반환---')
		    			console.log(events)
		    			successCallback(events);
		    		}
		    		
		    	}) 
		    },
		  //추가
		    select : function (addInfo) { // 캘린더에서 이벤트를 생성할 수 있다.
		    	console.log('추가');
		    	console.log(addInfo);
		    	console.log('----');
				const begin = moment(addInfo.start).format('YYYY-MM-DD HH:mm') ;
				const finish = moment(addInfo.end).format('YYYY-MM-DD HH:mm') ;
				const allDay = addInfo.allDay;
				/* $.ajax({
					type : 'get',
					url : '${contextPath}/schedule/write?start=' + begin + '&end=' + finish +'&allday=' + allDay ,
					dataType : 'html',
					success : function (resData){
						console.log(resData)
						 $("div").html(resData); 
					}
					
				}) */
				
				window.open('${contextPath}/schedule/write?start=' + begin + '&end=' + finish +'&allday=' + allDay ,'일정 입력페이지','width=500,height=600');
		            	calendar.addEvent({
		                	start: addInfo.start,
		                	end: addInfo.end,
		                	allDay: addInfo.allDay,
		             	 })
			 },
		    
		    //수정
		     eventDrop: function (editInfo){
		    	 console.log('--info--');
		    	 console.log(editInfo);
		    	 const obj = new Object();
		    	 if (
		    	   confirm("'" + editInfo.event.title + "' 매니저의 일정을 수정하시겠습니까 ?")
		    	 ) {
		    	   obj.scheduleNo = editInfo.event.extendedProps.scheduleNo;
		    	   obj.scheduleTitle = editInfo.event._def.title;
		    	   obj.scheduleStart = moment(editInfo.event._instance.range.start)
		    	     .subtract(9, 'hour')
		    	     .format('YYYY-MM-DD HH:mm');
		    	   obj.scheduleEnd = moment(editInfo.event._instance.range.end)
		    	     .subtract(9, 'hour')
		    	     .format('YYYY-MM-DD HH:mm');
		    	   obj.scheduleAllday = editInfo.event.allDay;
		    	   
		    	   $(function modifyData() {
		    	     $.ajax({
		    	       type: 'put',
		    	       url: '${contextPath}/schedule',
		    	       dataType: 'json',
		    	       data: JSON.stringify(obj),
		    	       contentType: 'application/json',
		    	       success: function (resData) {
		    	         if (resData.updateResult) {
		    	           alert('수정 성공');
		    	           console.log('--수정--');
		    	           console.log(obj);
		    	         } else {
		    	           alert('수정 실패');
		    	         }
		    	       },
		    	     });
		    	   });
		    	 } else {
		    	   info.revert(); // 돌리기
		    	 }
	        }, 
		    
	        
			 
			 eventClick : function (removeInfo){	
				 const obj = new Object();
				 if (confirm("'" + removeInfo.event.title + "' 매니저의 일정을 삭제하시겠습니까 ?")) {
				   $(function deleteData() {
					   console.log('---삭제 이벤트---');
			           console.log(removeInfo.event);
			           obj.scheduleNo = removeInfo.event.extendedProps.scheduleNo;
			           obj.scheduleTitle = removeInfo.event._def.title;
			           obj.scheduleStart = removeInfo.event._instance.range.start;
			           obj.scheduleEnd = removeInfo.event._instance.range.end;
				     $.ajax({
				       type: 'delete',
				       url: '${contextPaht}/schedule',
				       dataType: 'json',
				       data: JSON.stringify(obj),
				       contentType: 'application/json',
				       success: function (resData) {
				         if (resData.deleteResult > 0) {
				           alert('삭제 성공');
				           removeInfo.event.remove();
				         } else {
				           alert('삭제 실패');
				         }
				       },
				     });
				   });
				 } else {
				   removeInfo.jsEvent.preventDefault();
				 } 
             },
             
             customButtons: {
            	 
            	 write :{
            		text : '일정입력',
            		click: function(){
            			let schedule = JSON.stringify({
            				'scheduleTitle' : $('#title').val(),
            				'scheduleStart' : $('#start').val(),
            				'scheduleEnd' : $('#end').val(),
            				'scheduleAllday' : $('#allday').val(),
            			});
            			$.ajax({
            				type : 'post',
            				url : '${contextPath}/schedule',
            				data : schedule,
            				contentType : 'application/json',
            				
            				dataType: 'json',
            				success : function(resData) {
            					if(resData.insertResult > 0 ){
            						alert('일정이 등록되었습니다');
            					/* 	$(opener.location).attr('href','javascript:fn_fullcalendar()');  */
            					/* opener.parent.location.reload(); */
            						window.close();
            					} else {
            						alert('일정이 등록되지 않았습니다');
            					}
            					
            				},
            				error : function(jqXHR) {
            					alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText);
            					window.close();
            				}
            			}) 
            		}
            	 },
            	 
            	 attendance: {
            	      text: '출근',
            	      click: function() {
            	        $.ajax({
            	        	type: 'post',
            				url: '${contextPath}/attendance',
            				data: 'attendance=' + 1, 
            				dataType: 'json',
            				success: function(resData){
            					console.log(resData)
            					if(resData.insertAttendacne > 0) {
            						alert('출근하셨습니다');
            					} else if (resData.alreadyAttendace === 0 ) {
            						alert('이미 출근하셨습니다');
            					}
            				},
            				error: function(jqXHR){
            					 alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText); 
            				}
            	        })
            	      }
            	    },
             	 leave: {
		       	      text: '퇴근',
		       	      click: function() {
			       	     $.ajax({
	         	        	type: 'post',
	         				url: '${contextPath}/attendance',
	         				data: 'attendance=' + 2, 
	         				dataType: 'json',
	         				success: function(resData){
	         					console.log(resData)
	         					if (resData.earlyLeave === 1 && resData.updateLeaveWork === 1 ) {
	         						if(confirm('퇴근 시간 전입니다 조퇴 하시겠습니까?')){
		         						alert('조퇴입니다');
	         						}
	         					}else if(resData.updateLeaveWork > 0) {
	         						alert('퇴근하셧습니다.');
	         					}else if (resData.notAttendance === 0){
	         						alert('출근을 눌러주세요');
	         					}else if (resData.alreadyLeaveWork === 0){
	         						alert('이미 퇴근을 누르셨습니다.');
	         					} 
	         					
	         					
	         					
	         					
	         					
	         				},
	         				error: function(jqXHR){
	         					alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText); 
	         				}
	         	        })
       	        
       	   			 }
       	   		 },
             },
             
          
            	
           
		    
		  });
		  calendar.render();
	}
	

	function fn_write(){
		$('#btn_write').click(function(){
			console.log(  $(this).next().toggleClass('blind')  );
			/* $(this).nextSibling.toggleClass('blind'); */
		})
	}
	
	
</script>


</head>
<body>
<div id='calendar'></div>



<button id="btn_write">입력 버튼</button>
<div class="blind">
		<input type="hidden" id="allday" value="${allday}">
		<h1>일정 입력</h1>
		<div>
			<label for="title">제목</label> <input type="text" id="title">
		</div>
		<div>
			<label for="start">시작일</label> <input type="text" id="start"
				value="${start}">
		</div>
		<div>
			<label for="end">종료일</label> <input type="text" id="end"
				value="${end}">
		</div>
		<button id="btn_write">일정 등록</button>
		<button id="btn_close">취소</button>
</div>

</body>
</html>