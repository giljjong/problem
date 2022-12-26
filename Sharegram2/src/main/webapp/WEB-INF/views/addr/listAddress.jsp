<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${contextPath}/resources/css/addressCss/address.css">
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<style>
#empMenu, #empSubMenu{ list-style-type: none; margin: 0; padding:0;}
#empSubMenu>li{padding-left: 20px; margin: 0px;}
#empSubMenu>li:hover{cursor:pointer; background: rgb(233, 244, 248);}
#empMenu>li:hover{cursor:pointer; background: rgb(233, 244, 248);} 
 #profileImg{
     width:42px;
     height:42px;
     border:1px solid lightgray;
     border-radius: 50%;
 }
 
 #profileBigImg{
     width:350px;
     height:350px;
     border:1px solid lightgray;
     border-radius: 50%;               
 }
</style>
</head>
<body>

 <div style="height: 20px;"></div>
    <div class="adOuter">

    
        <div class="adContainer">

            <!-- 조직도 및 업체연락처 그룹영역 -->
            <div class="addMenu1">
                <button type="button" class="btn btn-primary centerBtn" data-toggle="modal" data-target="#addressAdd">새 연락처</button>   
                <hr width="80%">             
            </div>

            <!--  별표연락처 & 조직도 -->
            <div class="addMenu2_1">
            
                <!-- 별표연락처 -->
                <div class="starAdd" onclick="selectStarAdd();">
                    <span class='starYellow'>★</span><span style="font-size: 16px;"><b>별표연락처</b></span>
                </div>

                <hr width="80%">
                <!-- 조직도 -->
               	 <ul id="empMenu">
                    <li>
                        <div class="rowInline">
                            <span class="fontsize16" ><b>조직도</b></span> &nbsp;&nbsp;&nbsp;                            
                        </div>
                    </li>
                    <ul id="empSubMenu">                

                    </ul>
                </ul>
                            
            </div>
            
            <!-- 내연락처 -->
            <div class="addMenu2_2">
                <hr width="80%">
                <ul id="mainAddMenu">
                    <li>
                        <div class="rowInline">
                            <span class="fontsize16"><b>내 연락처</b></span> &nbsp;&nbsp;&nbsp;
                            <span  data-toggle="modal" onclick='$("#addGp").modal("show");'>
                             +
                            </span>
                        </div>
                    </li>
                    <ul id="subAddMenu">                   
                         
                    </ul>
                </ul>
                    
            </div>            
           
            
            <div class="addMenu3"></div> <!-- 주소록 테이블 영역-->
            <div class="addMain">

                <!-- 삭제 다중선택-->
                <br>
                <div id="deleteGroupArea">                
                    &nbsp;
                    <input type="checkbox" name="" id="cbx_chkAll"> &nbsp;

                    <!-- <a class="btn btn-sm btn-primary">메일보내기</a> -->
                    <!-- 내연락처일때만 삭제기능 -->
                    <!-- 삭제 > 모달 > 기능 정보넘기는거 어렵다면 그냥 모달창 띄우지말고 바로 삭제처리 -->
                    <button id="deleteFeat" type="button" class="btn btn-sm btn-secondary deleteAddGroup" onclick="deleteAddGroup();">삭제</button>                      

                </div>
                
                <br>
				
				<div id="tableArea">					
	                <!-- 1. 조직도 테이블 --> 
    	            <!-- 2. 내 연락처 테이블 -->
        	        <!-- 3. 별표연락처 -->              
				</div>
	
            </div>          

            <!-- 특정 멤버의 주소록 상세창영역-->
            <div class="detailAdd">           
                <br>
                <!-- 내연락처에만 있는 삭제/ 편집기능-->
                <div id="myAddChoiceArea" style="visibility:hidden;">                
                    <button type="button" class="btn btn-sm btn-warning openAddEdit" data-toggle="modal" data-target="#addressEdit">편집</button>
                    <button type="button" class="btn btn-sm btn-secondary deleteAddOne" onclick="deleteAdd();">삭제</button>      
                </div> 
                
               
                <div class="addBoxShadow" >
                    <br>
                    <table id="adDetailTb" width="85%">	
                        
			           <!--목록클릭 전-->                       
			           <p id="beforeClick" style="margin-left:30px">
			               <br>
			               연락처 상세정보를 보려면 연락처를 <br>
			               클릭하세요
			            </p> 
                        <!-- 주소록 상세보기 -->    
                        <!-- 별표연락처 & 내 연락처 상세보기 -->
                        
                    </table> 
                    <br>
                </div>
        
            </div>
                
            <!-- 페이징 영역-->
            <div class="pasingAdd" align="center" style="display:inline">
                 
            </div>
            
               <script>
            	$(function(){
            		
            		// [부서, 내연락처 목록]
            		selectDepList();
            		selectGpList(); 
            		
            		// [테이블조회 (부서/그룹코드 넘기고 테이블 조회)]
            		// 1) 사내조직도 직원 테이블
            		$("#empSubMenu").on("click", "li", function(){            			
            			selectdepTbList($(this).find(".depCd").val());
            			// 이렇게 바로 전달 *children().children() 이런식으로 내려가는것보단 find!
            		})    
            		// 2) 내 연락처 내 테이블
            		$("#subAddMenu").on("click", "li", function(){            			
            			selectAddTbList($(this).find(".groupNo").val());               			
            		})         
            		// 3) 별표연락처 테이블
            		selectStarAdd();
            		
            		//[상세보기]            		           	
            		// => 선언적함수로 거쳐서 값 전달하는것보다 바로 $function안에서 조회용 함수로 넘기는게 좋다
            		// 1) 사내직원 자세히 보기
            		$(document).on("click", "#dataCompanyTable tbody tr", function(){
            			selectDetailEmp($(this).find(".no").text());
            		})
            		// 2) 내 연락처 내 상세보기
            		$(document).on("click", "#dataAddTable tbody tr", function(){
            			selectDetailMyAdd($(this).find(".no").text(), $(this).parents("#dataAddTable").attr("groupno"));
            		})
            		// 3) 별표연락처 상세보기
            		$(document).on("click", "#dataStarAddTable tbody tr", function(){
            			selectDetailMyAdd($(this).find(".no").text());            			
            		}) 
            		
            		// [별 클릭시 별표연락처설정 실시간변경] => 연락처 번호, input:addStar, *groupno 속성에 박아서 전달했음
            		$(document).on("click", "#adDetailTb :checkbox", function(){
            			
            			// 체크박스 클릭해도 tr 클릭이벤트가 발생안하도록
        	        	event.stopPropagation(); 
            			
            			let addStar = ''; 
            			 if($(this).is(":checked")) {
            				addStar = 'Y'
            			 } else{
            				addStar = 'N'
            			 }            			
            			updateStarAdd($(this).next().next().val(), addStar, $(this).attr("groupno"));            		
            		})
            		
            		// Modal < 그룹 수정시 필요한 groupNo, groupName 전달
            		$(document).on("click", "#subAddMenu .editGpOpen", function(){
            			//console.log($(this).parent().siblings("#groupValues").children().eq(0).text());
            			//console.log($(this).parent().siblings("#groupValues").children().eq(1).val())
            			$("#editGp #groupName").val($(this).parent().siblings("#groupValues").children().eq(0).text());
            			$("#editGp #groupNo").val($(this).parent().siblings("#groupValues").children().eq(1).val());
            		})
            		
            		// 그룹삭제 ajax
            		$(document).on("click", "#subAddMenu .deleteAddGp", function(){  
            			if(confirm("그룹과 연락처 모두 삭제됩니다. 삭제하시겠습니까?")){
            				let groupNo= $(this).parent().siblings("#groupValues").children().eq(1).val();
            				
            				$.ajax({
            					
            					url:"deleteGp.ad",
            					data:{
            						groupNo:groupNo
            					},
            					success:function(result){
            						if(result == 'success'){
            							selectGpList();
            							$("#tableArea").html("");
            						}            						
            					},
            					error:function(){
            						console.log("그룹삭제 ajax실패");
            					}
            					
            				})
                			 
            			}         			
            		})
            		
            		 $("#cbx_chkAll").click(function() {
                         if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
                         else $("input[name=chk]").prop("checked", false);
                     });
            		
            		// ajax로 만든거 => 고치기
            		/*  $("input[name=chk]").click(function() {
		                    var total = $("input[name=chk]").length;
		                    var checked = $("input[name=chk]:checked").length;
		
		                    if(total != checked) $("#cbx_chkAll").prop("checked", false);
		                    else $("#cbx_chkAll").prop("checked", true); 
                		}); */                    
                     $(document).on("click", "#tableArea :checkbox", function(){
                     	var total = $("input[name=chk]").length;
                     	var checked = $("input[name=chk]:checked").length;
                     	if(total != checked) $("#cbx_chkAll").prop("checked", false);
	                    else $("#cbx_chkAll").prop("checked", true); 
                     });
                		
                	
                		
                	// 프로필이미지 클릭시 크게 보이는 modal을 위해 이미지경로 보내주기	
               		$(document).on("click", "#adDetailTb #profileImg", function(){
               			$("#profileModal #profileBigImg").attr("src", $(this).attr("src"));
               		});	
                		
                		
                        		
            	})
            	
            	// 부서별 목록 ajax
            	function selectDepList(){
            		
            		$.ajax({
            			url: "${contextPath}/add/depList",
            			success:function(resData){
            				//console.log(list);
            				let value = "";
            				
            				$.each(resData.deptList, function(i, dept){
            					value += '<li>'
                            		   +	 '<div class="btn-group dropright btnPadding">'
                                	   + 	 	'<button type="button" class="btn btn-text">'
                                       +	    	'<span style="font-size: 15px;">' + dept.deptName + '</span>'
                                       +			'<input type="hidden" class="depCd" value="' + dept.deptNo + '">'
                                	   +	     '</button>'
                                	   +      '</div>'
                                	   +  '</li>';                              	   
                                	   
            				});
                                $("#empSubMenu").html(value);	                                
            			},
            			error:function(){
            				console.log("부서리스트 ajax통신 실패");
            			}
            			
            		})            		
            	}
            	
            	// 내 연락처 그룹별 목록
            	function selectGpList(){
            		$.ajax({
            			url: "${contextPath}/add/myGroup/List",
            			success:function(resData){            				
            				let value = "";
            				let optionVal = "";
            				$.each(resData.myGroupList, function(i, myGroup){
            					  value += '<li>'
                           				 +	  '<div class="btn-group dropright btnPadding">'
                                		 + 		  '<button id="groupValues" type="button" class="btn btn-text">'
                                         + 				'<span style="font-size: 15px;">'+ myGroup.addrGroupName +'</span>'
                                         +				'<input type="hidden" class="groupNo" value="' + myGroup.addrGroupNo + '">'
                                		 +    	  '</button> &nbsp; &nbsp;';
                                		 
                              		 if(myGroup.addrGroupName != '그룹미지정' ){
                              			 value += '<button type="button" class="btn btn-text dropdown-toggle-split" data-toggle="dropdown" aria-expanded="false" style="padding: 0;">'
                                          	 +	    	 '፧'
                                      		 +   '</button>'
                                     		 +   '<div class="dropdown-menu">'                                
                                          	 +   	 	'<button type="button" class="dropdown-item fontsize13 editGpOpen" data-toggle="modal" onclick="' + "$('#editGp').modal('show');\"" + '>그룹수정</button>'
                                          	 +     		'<button type="button" class="dropdown-item fontsize13 deleteAddGp">그룹삭제</a>' 
                                     		 +   '</div>';
                                		 }
                              		 
                                	value +=  '</div>'
                        				  + '</li>';
                        				  
                        			optionVal += '<option value="' + myGroup.addrGroupNo + '">' + myGroup.addrGroupName + '</option>';	  
                        				 
            				});    
            				
            				
                        		$("#subAddMenu").html(value);	
                        		
                        		// 새연락처등록 , 연락처 편집에서 select 그룹선택  option값이 내가 그룹목록조회때마다 실시간 반영될것
                        		$("select[name=groupNo]").html(optionVal);
                        		
            			},
            			error:function(){
            				console.log("내연락처 목록용 ajax실패");
            			}
            			
            		})
            	}
            	
            	// 조직도목록 클릭시 테이블 조회용 ajax          	
            	function selectdepTbList(selectDepCd, cpage){            		
            		$.ajax({
            			type: "post",
            			url : "depTb.ad",
            			data : { 
            				depCd: selectDepCd,
            				cpage: cpage
            			},            			
            			success : function(result){
            				
            				let value="";
            					 value += '<table class="table" id="dataCompanyTable" depCd="'+ selectDepCd +'">'
    	                               +	'<thead>'
    	                               +         '<tr>'
    	                              /*  + 				'<th style="width: 15px;"></th>' */
                                       + 				'<th>사번</th>'
                                	   + 				'<th>이름</th>'
                                	   +				'<th>부서</th>'
                                	   +                '<th>직위</th>'
                                	   +  				'<th>이메일</th>'
                                	   +				'<th>핸드폰</th>'
                                	   + 				'<th>내선번호</th>'
                                	   +          '</tr>'                        
                                	   +    '</thead>'
                                	   +  '<tbody>'   ;                 						   
            					
            				let pageValue = "";
            				
            				let list = result.list;
            				let pi = result.pi; 
            				
            				if(list.length == 0){
            					value += "<tr>"
            							+	"<td colspan='7'>등록된 직원이 없습니다.</td>"            						
            							+"</tr>";
            				}else{
            					for(let i=0; i<list.length; i++){
            						value += 		'<tr>'
                                        	/* + 			'<td><input type="checkbox" name="chk"></td>' */
                                        	+ 			'<td class="no">'+ list[i].empNo +'</td>'
                                            +   		'<td class="name">'+ list[i].empName +'</td>'
                                        	+   		'<td>'+ list[i].depCd +'</td>'
                                        	+  			'<td>'+ list[i].posCd +'</td>'
                                        	+   		'<td>'+ list[i].empEmail + '</td>';
                                        	
                                        	if(list[i].empExtension != null){
                                        		 value   +=   '<td>'+ list[i].empExtension +'</td>';
                                        	}else{
                                        		 value   +=  '<td>'+ '' +'</td>'; 
                                        	}  
                                        	
                                        	if(list[i].empPhone != null){
                                        		 value   += '<td>' + list[i].empPhone + '</td>';
                                        	}else{
                                        		 value 	 += '<td>'+ '' +'</td>'; 
                                        	}
                                    value   +=  '</tr>'	;                                        	
            					}
            					
            					 if(pi.currentPage != 1){
                        			pageValue += "<button class='btn btn-sm btn-outline-primary' onclick='selectdepTbList("+ selectDepCd + ", "  + (pi.currentPage - 1) + ")'>&lt;</button>"	
                        		}
                        		
                        		for(let p=pi.startPage; p<=pi.endPage; p++) { 
                				   
                		   			if(p == pi.currentPage) { 
                				   			pageValue += "<button class='btn btn-sm btn-outline-primary' disabled>"  + p  + "</button>"
                				   	}else {
                				   			pageValue += "<button class='btn btn-sm btn-outline-primary' onclick='selectdepTbList("+ selectDepCd + ", "  + p +")'>" + p + "</button>"
                		           	} 
                		         }     
                         
                		         if(pi.currentPage != pi.maxPage) {
                		        	  pageValue +=	"<button class='btn btn-sm btn-outline-primary' onclick='selectdepTbList(" + selectDepCd + ", " + (pi.currentPage + 1) + ")'>&gt;</button>"
                		         }  
            				}
            				
            				value   +=	'</tbody>'
                        			+ '</table>';
            				
            				 $("#tableArea").html(value); 
            				 $(".pasingAdd").html(pageValue); 
            				 $("#deleteFeat").attr("style", "visibility:hidden");   
            				 $("#cbx_chkAll").attr("style", "visibility:hidden");
            				 $("#addTitle").html("<h4><b>"+ list[0].depCd +"</b></h4>");            				             				 
            				            				
            			},
            			error:function(){
            				console.log("조직도 주소록 테이블 조회용 ajax실패");
            			}
            			
            		
            		})
            	}
            	
            	// 조직도테이블 > 상세보기          	
            	function selectDetailEmp(empNo){
            		$.ajax({
            			url:"detailEmp.ad",
            			type:"post",
            			data:{
            				empNo:empNo
            			},
            			success:function(result){            				
            				let value = "";
            				    value += '<thead>'
                            		 	+		'<tr>'
                            		 	+	        '<th rowspan="2"><img id="profileImg" src="';
                            	
                            if(result.empProfile != null){
                            	value +=  result.empProfile;
                            }else{
                            	value += 'resources/profile_images/defaultProfile.png';
                            }		 	
                            	value  +=			'" data-toggle="modal" onclick="' + "$('#profileModal').modal('show');\"" + '></th>'
                                		+			'<th align="left"><h5><b>'+ result.empName +'</b></h5></th>'                               
                                		+           '<th  align="right">'
                                    	+				'<a class="material-symbols-outlined aHover" style="text-decoration: none;" href="selectEmail.ma?email='+ result.empEmail +'">mail</a>'
                                		+			'</th>'
                                		+			'<th><button type="button" class="material-symbols-outlined aHover btn-text" data-toggle="modal" data-target="#addressChat">chat</button></th>'
                           				+		 '</tr>'                       
                        				+'</thead>'
                       					+'<tbody>'               
                            			+		'<tr>'
                                		+			'<td class="fontSmallSize">부서</td>'
                                		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ result.depCd +'</td>'
                            			+		'</tr>'
                            			+		'<tr>'
                                		+			'<td class="fontSmallSize">직급</td>'
                                		+ 			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ result.posCd +'</td>'
                            			+ 		'</tr>'
           								+		 '<tr>'
                                		+			'<td colspan="5"> <hr style="width: 100%;"> </td>'
                           				+ 		'</tr>'
                          				+		'<tr>'
			                       		+			'<td class="fontSmallSize">이메일</td>'
			                    		+			'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ result.empEmail+'</td>'
			                			+       '</tr>'
			                			+		'<tr>'
		                      			+ 			'<td class="fontSmallSize">내선번호</td>';		                			
			                			
                           
                           if(result.empExtension != null){
                        	   		value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ result.empExtension+'</td>'
                           }
		                    		value +=	'</tr>'
		                    			  + 	 '<tr>'
				                       	  +			'<td class="fontSmallSize">휴대전화</td>';
                           
                           if(result.empPhone != null){
                        	   value += 			'<td colspan="4" class="fontMiddleAdd">&nbsp;&nbsp;' + result.empPhone + ' </td>';			               			  
                           }
                            			                    
                           		value	+=		'</tr>'
                           				+       '<tr>'
                                		+			'<td colspan="5"> <hr style="width: 97%;"> </td>'
                            			+		'</tr>'
			                            +		'<tr>'
                                		+			'<td class="fontSmallSize">입사일</td>'
                                		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ result.empEnrollDate+ '</td>'
                            			+		'</tr>'                             
                        				+'</tbody>'; 
                        				
                        	$("#beforeClick").remove();		
                        	$("#adDetailTb").html(value);	
                        	$("#myAddChoiceArea").attr("style", "visibility:hidden; margin-left:30px;");
                        	                        	                        				
            			},
            			error:function(){
            				console.log("조직도 직원 상세보기용 ajax 실패");
            			}
            		})
            	}
            	            	
            	// 내 연락처 목록클릭 시 조회 테이블
            	function selectAddTbList(groupNo, cpage){
            		
            		$.ajax({
            			type: "post",
            			url : "myAdTb.ad",
            			data : { 
            				groupNo: groupNo,
            				cpage: cpage
            			},            			
            			success : function(result){
            				
            				let value="";
            					 value += '<table class="table" id="dataAddTable" groupno="'+ groupNo + '">'
    	                               +	'<thead>'
    	                               +         '<tr>'
    	                               +				'<th style="width:10px"></th>'
    	                               +				'<th style="width: 10px;"></th>'
    	                               +				'<th>번호</th>'
    	                               +				'<th>이름</th>'
    	                               +				'<th>회사</th>'
    	                               +				'<th>부서</th>'
    	                               +				'<th>직위</th>'                
    	                               +				'<th>휴대전화</th>'      
                                	   +          '</tr>'                        
                                	   +    '</thead>'
                                	   +  '<tbody>'   ;                 						   
            					
            				let pageValue = "";
            				
            				let list = result.list;
            				let pi = result.pi;   
            				
            				if(list.length == 0){
            					value += "<tr>"
            							+	"<td colspan='8'>등록된 연락처가 없습니다.</td>"            						
            							+"</tr>";
            				}else{
            					for(let i=0; i<list.length; i++){
            						value += 		'<tr>'
                                        	+ 			'<td><input type="checkbox" name="chk" value="'+ list[i].addressNo  +'"></td>'
                                        	+			'<td>'
                                            +				'<span class="';
                                    if(list[i].addressStar == 'Y'){
                                    		value +=  'starYellow';
                                    }else{
                                    	value += 'starWhite';
                                    }     
                                            
                                     value  +=                '">★</span>'                           
                                        	+			'</td>'
                                        	+			'<td class="no">'+ list[i].addressNo +'</td>'
                                        	+			'<td class="name">'+ list[i].addressName +'</td>'
                                        	+			'<td>'+ list[i].addressCompany +'</td>'
                                        	+			'<td>'+ list[i].addressDepartment +'</td>'
                                        	+			'<td>'+ list[i].addressPosition +'</td>'                                        	       
                                        	
                                        	if(list[i].addressTel != null){
                                        		 value   +=   '<td>'+ list[i].addressTel +'</td>';
                                        	}else{
                                        		 value   +=  '<td>'+ '' +'</td>'; 
                                        	}                                        	
                                    value   +=  '</tr>'	;                                        	
            					}
            					
            					 if(pi.currentPage != 1){
                        			pageValue += "<button class='btn btn-sm btn-outline-primary' onclick='selectAddTbList("+ groupNo + ", "  + (pi.currentPage - 1) + ")'>&lt;</button>"	
                        		}
                        		
                        		for(let p=pi.startPage; p<=pi.endPage; p++) { 
                				   
                		   			if(p == pi.currentPage) { 
                				   			pageValue += "<button class='btn btn-sm btn-outline-primary' disabled>"  + p  + "</button>"
                				   	}else {
                				   			pageValue += "<button class='btn btn-sm btn-outline-primary' onclick='selectAddTbList("+ groupNo + ", "  + p +")'>" + p + "</button>"
                		           	} 
                		         }     
                         
                		         if(pi.currentPage != pi.maxPage) {
                		        	  pageValue +=	"<button class='btn btn-sm btn-outline-primary' onclick='selectAddTbList(" + groupNo + ", " + (pi.currentPage + 1) + ")'>&gt;</button>"
                		         }  
            				}
            				
            				value   +=	'</tbody>'
                        			+ '</table>';
            				
                        			//console.log(value);
            				$("#tableArea").html(value);
            				$(".pasingAdd").html(pageValue); 
            				            				            				
            				$("#addTitle").html("<h4><b>내 연락처</b></h4>");      
            				$("#deleteFeat").attr("style", "visibility:visible");
            				$("#cbx_chkAll").attr("style", "visibility:visible");
            				
            			},
            			error:function(){
            				console.log("내연락처 주소록 테이블 조회용 ajax실패");
            			}       		
            		})
            	} 
            	
            	// 내연락처 & 별표연락처 상세보기
            	function selectDetailMyAdd(addressNo, groupNo){
            		$.ajax({
            			url : "detailMyAdd.ad",
            			type:  "post",
            			data:{
            				addressNo:addressNo
            			},
            			success:function(result){
            				let value = "";
        				    value += '<thead>'
                        		 	+		'<tr>'
                        		 	+	        '<th class="Addstar">'
                        		 	+				'<input type="checkbox" name="addStar" value="Y" id="rate2" groupno="' + groupNo + '"';
                        	if(result.addressStar == 'Y'){
                        	 value +=				'checked';
                        	}	 	
                        		 	
                        	value 	+=  			'><label for="rate2">★</label>'   
                        			+				'<input type="hidden" class="no" value="'+ result.addressNo +'">'
                        		 	+			'</th>'
                            		+			'<th align="left"><h5><b>'+ result.addressName +'</b></h5></th>';
                          	if(result.addressNickName != null){
                          		value += '<th class="fontSmallSize" style="width: 70px;">'+ result.addressNickName+'</th>';
                          	} 		
                             value +=           '<th  align="right">'
                                	+				'<a class="material-symbols-outlined aHover" style="text-decoration: none;" href="selectEmail.ma?email='+ result.addressEmail +'">mail</a>'
                            		+			'</th>'
                       				+		 '</tr>'                       
                    				+'</thead>'
                   					+'<tbody>' 
                   					+		'<tr>'
			                        +           '<td class="fontSmallSize">회사</td>'
			                        +           '<td colspan="3" class="fontMiddleAdd">&nbsp;'+ result.addressCompany +'</td>'
			                        +       '</tr>'		
                        			+		'<tr>'
                            		+			'<td class="fontSmallSize">부서</td>'
                            		+			'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ result.addressDepartment +'</td>'
                        			+		'</tr>'
                        			+		'<tr>'
                            		+			'<td class="fontSmallSize">직급</td>'
                            		+ 			'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ result.addressPosition +'</td>'
                        			+ 		'</tr>'
       								+		 '<tr>'
                            		+			'<td colspan="5"> <hr style="width: 100%;"></td>'
                       				+ 		'</tr>'
                      				+		'<tr>'
		                       		+			'<td class="fontSmallSize">이메일</td>'
		                    		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ result.addressEmail+'</td>'
		                			+       '</tr>'
		                			+		'<tr>'
	                      			+ 			'<td class="fontSmallSize">내선번호</td>';		                			
		                			
                       
                      	 if(result.addressExtensionNo != null){
                    	   		value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ result.addExtensionNo+'</td>'
                      	 }
	                    		value +=	'</tr>'
	                    			  + 	 '<tr>'
			                       	  +			'<td class="fontSmallSize">휴대전화</td>';
                       
                      	 if(result.addressTel != null){
                    	 	   value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp;' + result.addressTel + ' </td>';			               			  
                      	 }
		                       value +=		'</tr>'
		             			 	 + 	 	'<tr>'
			                       	 +			'<td class="fontSmallSize">FAX</td>';
                       	if(result.addressFax != null){
                   	 	       value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp;' + result.addressFax + ' </td>';			               			  
                     	}            	 
                        			                    
                       		   value +=		'</tr>'
                       				 +       '<tr>'
                            		 +			'<td colspan="5"> <hr style="width: 97%;"> </td>'
                        			 +		'</tr>'
		                             +		'<tr>'
                            		 +			'<td class="fontSmallSize">메모</td>';
                            		
                          if(result.addressMemo != null ){
                        	  value += 			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ result.addressMemo+ '</td>';
                          } 		
                              value	+=		'</tr>'                             
                    				+'</tbody>'; 
                    			
                    	$("#beforeClick").remove();		
                    	$("#adDetailTb").html(value);	
                    	$("#myAddChoiceArea").attr("style", "visibility:visible; margin-left:30px;");
                    	
                    	// 편집버튼 클릭 시 편집모달창에 값 뿌리기                    	
	                    $(document).ready(function(){
	             			$(".openAddEdit").click(function(){	   
	             				const el = $("#addressEdit table");
	             				el.find("#addressNo").val(addressNo);
	             				//console.log(addressNo);  // 얘는 왜 result.addressNo가 아닐까 => 이 함수를 호출할때 매개변수로 받았음
	             				//console.log(result.addressNo);
	             				el.find("#addressName").val(result.addressName);
	             				el.find("#addressCompany").val(result.addressCompany);
	             				el.find("#addressEmail").val(result.addressEmail);
	             				el.find("#addressTel").val(result.addressTel);
	             				el.find("#addExtensionNo").val(result.addExtensionNo);
	             				el.find("#addressFax").val(result.addressFax);
	             				el.find("#addressMemo").val(result.addressMemo);	             				
	             			});
	             				             			
	             		});                      	
                                        	
            			},
            			error:function(){
            				console.log("내연락처 내 상세보기 ajax 실패");
            			}
            			
            			
            		})
            	}            	     	
            	            	// 이거 하기. 매퍼까지는 만들어놓음 서비스단 구현
            	// 별표연락처 테이블 조회            	            	
            	function selectStarAdd(page){
            		$.ajax({
            			url: "${contextPath}/add/starList",
            			type: "post",
            			data: {
            				page:page
            			},
            			success:function(resData){
            				var starList = resData.starList;
            				var value='';       					
            				var paging = '';
       						
       						value += '<table class="table" id="dataStarAddTable">' 
       	                   		 	+ 	'<thead>'
                            		+   	'<tr>'
                                	+			'<th style="width:10px"></th>'
                               		+			'<th style="width: 10px;"></th>'		   
                                	+			'<th>번호</th>'
                                	+			'<th>이름</th>'
    		   						+			'<th>이메일</th>'	
                                	+			'<th>회사</th>'
                                	+  			'<th>팩스번호</th>'                
                                	+			'<th>휴대전화</th>'       
                            		+		'</tr>'
                        			+	'</thead>'	
                					+ 	'<tbody>';
                					
       						if(starList.length == 0){
            					value += "<tr>"
            							+	"<td colspan='9'>등록된 연락처가 없습니다.</td>"            						
            							+"</tr>";
            				}else{
            					$.each(starList, function(i, star){
            						value += 		'<tr>'
                                        	+ 			'<td><input type="checkbox" name="chk" value="'+ star.personalNo +'"></td>'
                                        	+			'<td>'
                                            +				'<span class="';
                                    if(star.addressStar == 'Y'){
                                    		value +=  'starYellow';
                                    }else{
                                    	value += 'starWhite';
                                    }     
                                            
                                     value  +=                '">★</span>'                           
                                        	+			'</td>'
                                        	+			'<td class="no">'+ star.personalNo +'</td>'
                                        	+			'<td class="name">' + star.addrName + '</td>'
                                        	+			'<td>'+ star.email +'</td>'
                                        	+			'<td>'+ star.company +'</td>'
                                        	+			'<td>'+ star.fax +'</td>';                        
                                        	
                                        	if(star.addrPhone != null){
                                        		 value   +=   '<td>'+ star.addrPhone +'</td>';
                                        	}else{
                                        		 value   +=  '<td>'+ '' +'</td>'; 
                                        	}                                        	
                                    value   +=  '</tr>'	;                                        	
            					});
                		         
                		         $('.pasingAdd').empty();
                					var pageUtil = resData.pageUtil;
                					var paging = '';
                					// 이전 블록
                					if(pageUtil.beginPage != 1) {
                						paging += '<span class="enable_link" data-page="'+ (pageUtil.beginPage - 1) +'">◀</span>';
                					}
                					// 페이지번호
                					for(let p = pageUtil.beginPage; p <= pageUtil.endPage; p++) {
                						if(p == $('#page').val()){
                							paging += '<strong>' + p + '</strong>';
                						} else {
                							paging += '<span class="enable_link" data-page="'+ p +'">' + p + '</span>';
                						}
                					}
                					// 다음 블록
                					if(pageUtil.endPage != pageUtil.totalPage){
                						paging += '<span class="enable_link" data-page="'+ (pageUtil.endPage + 1) +'">▶</span>';
                					}
                					$('#paging').append(paging);
                		         
            				}
            				
            				value   +=	'</tbody>'
                        			+ '</table>';
                        
                    $("#tableArea").html(value);
       			    $(".pasingAdd").html(paging);
       			 	$("#deleteFeat").attr("style", "visibility:visible"); 
       			    $("#cbx_chkAll").attr("style", "visibility:visible");
       				$("#addTitle").html("<h4><b>별표연락처</b></h4>");        				     	
       						
            			}, 
            			error:function(){
            				console.log("별표연락처 조회 ajax실패")
            			}    
            		})
            	}
            	
            	// 별 클릭시 실시간 별표연락처 변경
            	function updateStarAdd(addNo, addStar, groupNo){
            		$.ajax({
            			url:"updateStar.ad",
            			type: "post",
            			data: {
            				addressNo:addNo,
            				addressStar:addStar
            			},
            			success:function(result){
            				if(result == "success"){ 
            					
        						if($("#tableArea>table").is("#dataStarAddTable")){
        							// =>별표목록리스트 조회하는 ajax 호출
        							selectStarAdd();
        						}else{
        							selectAddTbList(groupNo);
        						}
        						
        						
        					}
            			},
            			error:function(){
            				console.log("실시간 별표연락처 변경 ajax 실패");
            			}
            		})
            		
            	}
            	
            	// 그룹 수정용 ajax
            	function ajaxEditGp(){
            		let groupNo =  $("#editGp #updateGpModalBd").find("#groupNo").val();
            		let groupName = $("#editGp table").find("#groupName").val();
            		if(groupName.trim() != 0 ){
            			$.ajax({
                			url: "updateGp.ad",
                			data:{
                				groupNo:groupNo,
                				groupName:groupName
                			},
                			success:function(result){
                				if(result == 'success'){
                					// 처리 후 모달창 닫기
                					$('#editGp').modal('hide');
                					// 연락처 목록 조회
                					selectGpList(); 
                				}
                			},
                			error:function(){
                				console.log("그룹수정용 ajax실패");
                			}
                		})
            		}else{
            			alert("그룹이름을 입력해주세요.");
            			//$("#groupName").focus();            			 
            		}
            		
            	}
            	
            	// 그룹등록용 ajax
            	function ajaxAddGp(){
            		let employeeNo = $("#addGpTb").find("#employeeNo").val();
            		let groupName = $("#addGpTb").find("#groupName").val();
            		if(groupName.trim() != 0 ){
            			$.ajax({
                			url:"insertGp.ad",
                			data:{
                				employeeNo:employeeNo,
                				groupName:groupName
                			},
                			success:function(result){
                				if(result == "success"){
                					// 처리 후 모달창 닫기 + 비워주기
                					$("#addGpTb").find("#groupName").val("");
                					$('#addGp').modal('hide');
                					// 연락처 목록 조회
                					selectGpList(); 
                				}
                			},
                			error:function(){
                				console.log("그룹등록용 ajax 실패");
                			}
                		})
            		}else{
            			alert("그룹이름을 입력해주세요");
            		}
            		
            	}
            	
            	<!--==================================== 삭제용 script ======================================= -->
                             
                //내연락처 상세보기 삭제 
                function deleteAdd(){
                    if(confirm("해당 연락처를 삭제하시겠습니까?")){
						//let url = "deleteAdd.ad?addressNo=" + $("#adDetailTb .no").val();
						//console.log($("#adDetailTb .no").val());
						//$(".deleteAddOne").attr("href", url);	
						let addressNo = $("#adDetailTb .no").val(); 
						$.ajax({
							url:"deleteAdd.ad",
							data:{ addressNo:addressNo								
							},
							success:function(result){
								if(result == "success"){
                    				
                    				// 각각의 테이블 조회하는 ajax 호출
                    				if($("#tableArea>table").is("#dataStarAddTable")){                					
                    					selectStarAdd();
                    				}else{
                    					let groupNo = $("#dataAddTable").attr("groupNo");
                    					//console.log(groupNo);
                    					selectAddTbList(groupNo);
                    				}
                    				// 상세보기 영역 비워주기
                    				$("#adDetailTb").html("삭제된 연락처정보 입니다.");
                    			  }    
							},
							error:function(){
                				console.log("개별연락처 삭제 ajax 실패");
                			}
						})
                    }
                }
                
               // 다중선택 연락처 삭제 1-1 check된 항목들의 연락처 번호를 담고, 만약 체크 안한 상태로 삭제버튼 클릭시 안넘어가도록 조건 처리
               function deleteAddGroup(){
                	var arr = new Array();
                	$("input[name='chk']:checked").each(function(){
                		arr.push(($(this).val()));                		
                	});
                	
                	if(arr.length > 0){
                		ajaxDeleteAddGroup(arr);
                	}else{
                		alert("연락처를 선택해주세요");
                	}
                	
                	
                } 
                
                function ajaxDeleteAddGroup(arr){
                	if(confirm("연락처를 삭제하시겠습니까?")){
                		$.ajax({
                    		url : "deleteAdds.ad",
                    		// ajax에서 배열의 값을 java단으로 넘기고 싶을땐 꼭해줘야함!!
                    		traditional:true,
                    		data : {
                    			addArr:arr
                    		},
                    		success:function(result){
                    			if(result == "success"){
                    				
                    				// 각각의 테이블 조회하는 ajax 호출
                    				// 지금 테이블이 별표연락처라면 삭제 후 다시 별표연락처를 조회하도록
                    				if($("#tableArea>table").is("#dataStarAddTable")){                					
                    					selectStarAdd();
                    				}else{
                    					let groupNo = $("#dataAddTable").attr("groupNo");
                    					//console.log(groupNo);
                    					
                    					// 다시 조회
                    					selectAddTbList(groupNo);     
                    					
                    					// 혹시 전체체크됐을때 기능 후 체크가 사라지도록
                				        $("#cbx_chkAll").prop("checked", false);
                    				}
                    				
                    				// 선택된게 있을수있으니 상세정보영역 비워주기
                    				$("#adDetailTb").html("");
                    				
                    			  }               				
                    			
                    		},
                    		error:function(){
                				console.log("다중선택 연락처 삭제 ajax 실패");
                			}
                    	})
                	}
                }
                
                <!--==================================== 다중선택 전체선택 script ======================================= -->
        
            </script>

</body>
</html>