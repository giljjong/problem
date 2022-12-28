<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

	<jsp:include page="../layout/header.jsp">
		<jsp:param value="주소록" name="title" />
	</jsp:include>
	
<link rel="stylesheet" href="${contextPath}/resources/css/addressCss/address.css">
<!-- 부트스트랩 4.6 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous"></script>
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
 
 	.blind{
 		display: none;
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
                    <span class='starYellow'>★</span><span style="font-size: 16px;"><b>주요연락처</b></span>
                </div>

                <hr width="80%">
                <!-- 조직도 -->
               	 <ul id="empMenu">
                    <li>
                        <div class="rowInline">
                            <span class="fontsize16" ><b>부서별연락처</b></span> &nbsp;&nbsp;&nbsp;                            
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
            
            <div class="addMenu3"></div>

            <!-- 주소록 테이블 영역-->
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
            
            <!--==================================== Modal ======================================= -->

            <!-- 새연락처 Modal -->
            <div class="modal fade" id="addressAdd" tabindex="-1" aria-labelledby="addressAddModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">                       
                        <div class="modal-body">                          
                            <form action="${contextPath}/add/personal/addr" method="post">
                                <table align="center">   
                                        <tr>
                                            <th class="Addstar" colspan="2">
                                                <input type="checkbox" name="importantCheck"  value="Y" id="rate3">
                                                <label for="rate3">★</label>      
                                                <input type="hidden" name="empNo" value="${loginUser.empNo }">                            
                                            </th>                                    
                                        </tr>                             
                                    <tr>
                                            <th>이름</th>  &nbsp;                                                                       
                                            <td><input class="formInput"  type="text" id="addrName" name="addrName" required></td>                                       
                                    </tr>
                                    <tr>
                                            <th>회사</th> &nbsp;
                                            <td><input class="formInput" type="text" name="company" required></td>                                       
                                    </tr>                                   
                                        <tr>
                                            <th>이메일</th> &nbsp;
                                            <td><input class="formInput" type="email" name="email" required></td>
                                        </tr>
                                        <tr>
                                            <th>휴대전화</th> &nbsp;
                                            <td ><input class="formInput" type="text" name="addrPhone" placeholder=" -도 함께 입력해주세요." maxlength="13"></td>
                                        </tr>
                                        <tr>
                                            <th>FAX</th> &nbsp; 
                                            <td><input class="formInput" type="text" name="fax"></td>
                                        </tr>
                                        <tr>
                                            <th>메모</th> &nbsp;
                                            <td><textarea style="resize: none;" maxlength="19" name="memo" id="addMemo1" cols="30" class="formInput"></textarea></td>                                        
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="end">
                                                <span id="addMemoContentcount1">0</span>
                                                <span class="blueColor">/20</span> 
                                            </td>
                                            <script>
                                                $(function(){
                                                    $("#addMemo1").keyup(function(){
                                                        $("#addMemoContentcount1").text($(this).val().length); 
                                                    })
                                                })
                                            </script>
                                        </tr>
                                        <tr>
                                            <th>그룹</th>
                                            <td>
                                                <select name="addrGroupNo" class="formInput">
                                                </select>
                                            </td>
                                        </tr>
                                    
                                </table>
                                <br><br>
                                <div align="center">
                                    <button type="submit" class="btn btn-sm btn-primary">등록</button>
                                    <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal">취소</button>
                                </div>
                                
                            </form>
                            <br>
                        </div>                    
                    </div>
                </div>
            </div>
                                
            <!-- 내연락처 편집 Modal -->
            <div class="modal fade" id="addressEdit" tabindex="-1" aria-labelledby="addressEditModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">                        
                        <div class="modal-body">                          
                            <form action="updateAdd.ad" method="post">
                                <table id="addEdit" align="center">  
                                   <tr>
                                        <th colspan="2">                                           
                                            <input type="hidden" name="addressNo" id="addressNo" value="">                             
                                        </th>                                    
                                    </tr>                               
                                    <tr>
                                            <th >이름</th>  &nbsp;                                                                       
                                            <td ><input class="formInput"  type="text" id="addrName" name="addrName"  required></td>                                                                             
                                    </tr>
                                    <tr>
                                            <th>회사</th> &nbsp;
                                            <td><input class="formInput" type="text" name="company" id="company" required></td>                                       
                                    </tr>                                     
                                        <tr>
                                            <th>이메일</th> &nbsp;
                                            <td><input class="formInput" type="email" name="email" id="email" required></td>
                                        </tr>
                                        <tr>
                                            <th>휴대전화</th> &nbsp;
                                            <td ><input class="formInput" type="text" name="addrPhone" id="addrPhone" placeholder=" -도 함께 입력해주세요." maxlength="13"></td>
                                        </tr>
                                        <tr>
                                            <th>FAX</th> &nbsp; 
                                            <td><input class="formInput" type="text" name="fax" id="fax"></td>
                                        </tr>
                                        <tr>
                                            <th>메모</th> &nbsp;
                                            <td><textarea style="resize: none;" maxlength="19" name="memo" id="memo" cols="30" class="formInput"></textarea></td>                                        
                                        </tr>                                       
                                        <tr>
                                            <th>그룹</th>
                                            <td>
                                                <select name="addrGroupNo" class="formInput">
                                                </select>
                                            </td>
                                        </tr> 
                                    
                                </table>
                                <br>
                                <div align="center">
                                    <button type="submit" class="btn btn-sm btn-primary">수정</button>
                                    <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal">취소</button>
                                </div>
                                
                            </form>
                        </div>
                        
                    </div>
                </div>
            </div>

            
            <!-- 내연락처 그룹추가 Modal -->
            <div class="modal fade" id="addGp" tabindex="-1" aria-labelledby="addGpModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered ">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addGpModalLabel">그룹추가</h5>
                            <button type="button" class="close" onclick='$("#addGp").modal("hide");' aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">                            
                           
                           <table align="center" id="addGpTb">
                               <tr>
                                   <td><input type="text" id="addrGroupName" name="addrGroupName" placeholder="그룹명을 입력해주세요" required></td>
                                   <td><button type="button" class="btn btn-sm btn-primary" onclick="ajaxAddGp();">등록</button></td>
                                   <td><button type="button" class="btn btn-sm btn-secondary" onclick='$("#addGp").modal("hide");'>취소</button></td>
                               </tr>
                           </table>                               
                          
                            <!-- form submit 말고 등록버튼 클릭시 ajax로 insert하게끔 success function에서 $("#addGp").modal("hide"); -->
                        </div>
                        <div class="modal-footer">                      
                        
                        </div>
                    </div>
                </div>
            </div>

            <!-- 내연락처 그룹수정 Modal -->
            <div class="modal fade" id="editGp" tabindex="-1" aria-labelledby="editGpModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered ">
                    <div class="modal-content">
                        <div class="modal-header" >   
                            <h5 class="modal-title" id="addGpModalLabel">그룹수정</h5>
                            <button type="button" class="close" onclick="$('#editGp').modal('hide');" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>                     
                        </div>
                        <div class="modal-body" id="updateGpModalBd">        
                                            
                             <input type="hidden" name="empNo"  value="${loginUser.empNo }">
                             <input type="hidden" name="addrGroupNo" id="addrGroupNo" value="">
                             <table align="center">
                                 <tr>
                                     <td>
                                         <input type="text" name="addrGroupName" id="addrGroupName"  value="" required>
                                     </td>
                                     <td><button type="button" class="btn btn-sm btn-primary" onclick="ajaxEditGp();">수정</button></td>
                                     <td><button type="button" class="btn btn-sm btn-secondary" onclick="$('#editGp').modal('hide');">취소</button></td>
                                 </tr>
                             </table>                             
                           
                        </div>
                        <div class="modal-footer">                        
                        </div>
                    </div>
                </div>
            </div>
         </div>
        
    </div>
    
    
    <!-- 프로필 크게보기 Modal -->
     <div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
         <div class="modal-dialog modal-dialog-centered">
             <div class="modal-content" align="center">   
                 <div class="modal-header">
                     <h5 class="modal-title" id="profileModalLabel">프로필이미지</h5>                        
                     <button type="button" class="close" onclick='$("#profileModal").modal("hide");' aria-label="Close">
                         <span aria-hidden="true">&times;</span>
                     </button>
                 </div>                 
                 <div class="modal-body">
                    
                    <img id="profileBigImg">
                                  
                 </div>
                
             </div>
         </div>
     </div>
     <div class="blind">
     	<form name="write_frm" class="blind">
			<input type="hidden" name="email">
		</form>
     </div>
    
    
    
     <script>
            	$(function(){
            		
            		// [부서, 내연락처 목록]
            		selectDepList();
            		selectGpList(); 
            		
            		// [테이블조회 (부서/그룹코드 넘기고 테이블 조회)]
            		// 1) 사내조직도 직원 테이블
            		$("#empSubMenu").on("click", "li", function(){            			
            			selectdepTbList($(this).find(".deptNo").val());
            			// 이렇게 바로 전달 *children().children() 이런식으로 내려가는것보단 find!
            		})    
            		// 2) 내 연락처 내 테이블
            		$("#subAddMenu").on("click", "li", function(){            			
            			selectAddTbList($(this).find(".addrGroupNo").val());               			
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
            			selectDetailMyAdd($(this).find(".no").text(), $(this).parents("#dataAddTable").attr("addrGroupNo"));
            		})
            		// 3) 별표연락처 상세보기
            		$(document).on("click", "#dataStarAddTable tbody tr", function(){
            			selectDetailMyAdd($(this).find(".no").text());            			
            		}) 
            		
            		// [별 클릭시 별표연락처설정 실시간변경] => 연락처 번호, input:importantCheck, *addrGroupNo 속성에 박아서 전달했음
            		$(document).on("click", "#adDetailTb :checkbox", function(){
            			
            			// 체크박스 클릭해도 tr 클릭이벤트가 발생안하도록
        	        	event.stopPropagation(); 
            			
            			let importantCheck = ''; 
            			 if($(this).is(":checked")) {
            				 importantCheck = 'Y'
            			 } else{
            				 importantCheck = 'N'
            			 }            			
            			updateStarAdd($(this).next().next().val(), importantCheck, $(this).attr("addrGroupNo"));            		
            		})
            		
            		// Modal < 그룹 수정시 필요한 addrGroupNo, addrGroupName 전달
            		$(document).on("click", "#subAddMenu .editGpOpen", function(){
            			//console.log($(this).parent().siblings("#groupValues").children().eq(0).text());
            			//console.log($(this).parent().siblings("#groupValues").children().eq(1).val())
            			$("#editGp #addrGroupName").val($(this).parent().siblings("#groupValues").children().eq(0).text());
            			$("#editGp #addrGroupNo").val($(this).parent().siblings("#groupValues").children().eq(1).val());
            		})
            		
            		// 그룹삭제 ajax
            		$(document).on("click", "#subAddMenu .deleteAddGp", function(){  
            			if(confirm("그룹과 연락처 모두 삭제됩니다. 삭제하시겠습니까?")){
            				let addrGroupNo= $(this).parent().siblings("#groupValues").children().eq(1).val();
            				
            				$.ajax({
            					type : 'get',
            					url : "${contextPath}/remove/group",
            					data : {
            						addrGroupNo : addrGroupNo
            					},
            					success : function(resData){
            						if(resData.result == true){
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
                                       +			'<input type="hidden" class="deptNo" value="' + dept.deptNo + '">'
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
                                         +				'<input type="hidden" class="addrGroupNo" value="' + myGroup.addrGroupNo + '">'
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
                        		$("select[name=addrGroupNo]").html(optionVal);
                        		
            			},
            			error:function(){
            				console.log("내연락처 목록 ajax실패");
            			}
            			
            		})
            	}
            	
            	// 조직도목록 클릭시 테이블 조회용 ajax          	
            	function selectdepTbList(deptNo, page){
					var pageNo = 0;
            		if(page == null) {
            			pageNo = 1;
            		} else {
            			pageNo = page;
            		}
            		
            		$.ajax({
            			type: "post",
            			url : "${contextPath}/get/dept/empList",
            			data :  'deptNo=' + deptNo + '&page=' + pageNo,
            			dataType : 'json',
            			success : function(resData){
            				
            				let value="";
            					 value += '<table class="table" id="dataCompanyTable" depCd="'+ deptNo +'">'
    	                               +	'<thead>'
    	                               +         '<tr>'
                                       + 				'<th>사번</th>'
                                	   + 				'<th>이름</th>'
                                	   +				'<th>부서</th>'
                                	   +                '<th>직위</th>'
                                	   +  				'<th>이메일</th>'
                                	   +				'<th>핸드폰</th>'
                                	   + 				'<th>팩스</th>'
                                	   +          '</tr>'                        
                                	   +    '</thead>'
                                	   +  '<tbody>'   ;                 						   
            					
            				let pageValue = "";
            				var empList = resData.empAddrsList;
            				
            				if(empList.length == 0){
            					value += "<tr>"
            							+	"<td colspan='7'>등록된 직원이 없습니다.</td>"            						
            							+"</tr>";
            				}else{
            					$.each(empList, function(i, empAddr){
            						value += 		'<tr>'
                                        	+ 			'<td class="no">'+ empAddr.empNo +'</td>'
                                            +   		'<td class="name">'+ empAddr.name +'</td>'
                                        	+   		'<td>'+ empAddr.deptName +'</td>'
                                        	+  			'<td>'+ empAddr.jobName +'</td>'
                                        	+   		'<td>'+ empAddr.email + '</td>';
                                        	
                                        	if(empAddr.phone != null){
                                        		var no = empAddr.phone;
			            						var phone = no.slice(0,3) + '-' + no.slice(3, 8) + '-' + no.slice(8,11)
                                        		 value   += '<td>' + phone + '</td>';
                                        	}else{
                                        		 value 	 += '<td>'+ '' +'</td>'; 
                                        	}
                                    value   +=  '</tr>'	;                                        	
            					})
            				
            				$('.pasingAdd').empty();
            				var pageUtil = resData.pageUtil;
            				var paging = '';
            				// 이전 블록
            				if(pageUtil.beginPage != 1) {
            					paging += '<span class="enable_link" data-page="'+ (pageUtil.beginPage - 1) +'" onclick="selectdepTbList(' + (pageUtil.beginPage - 1) + ', ' + p + ')">◀</span>';
            				}
            				// 페이지번호
            				for(let p = pageUtil.beginPage; p <= pageUtil.endPage; p++) {
            					if(p == $('#page').val()){
            						paging += '<strong>' + p + '</strong>';
            					} else {
            						paging += '<span class="enable_link" data-page="'+ p +'" onclick="selectdepTbList(' + deptNo + ', ' + p + ')>' + p + '</span>';
            					}
            				}
            				// 다음 블록
            				if(pageUtil.endPage != pageUtil.totalPage){
            					paging += '<span class="enable_link" data-page="'+ (pageUtil.endPage + 1) +'" onclick="selectdepTbList(' + (pageUtil.endPage + 1) + ', ' + p + ')>▶</span>';
            				}
            				$('#paging').append(paging);
            				
            				value   +=	'</tbody>'
                        			+ '</table>';
            				
            				 $("#tableArea").html(value); 
            				 $(".pasingAdd").html(pageValue); 
            				 $("#deleteFeat").attr("style", "visibility:hidden");   
            				 $("#cbx_chkAll").attr("style", "visibility:hidden");
            				 $("#addTitle").html("<h4><b>"+ empList[0].deptNo +"</b></h4>");            				             				 
            				            				
            			}
            		},
        			error:function(){
        				console.log("조직도 주소록 테이블 조회 ajax실패");
        			}
            	})
            }
            	
            	// 조직도테이블 > 상세보기          	
            	function selectDetailEmp(empNo){
            		$.ajax({
            			url:"${contextPath}/get/emp/detail",
            			type:"post",
            			data:{
            				empNo:empNo
            			},
            			success:function(resData){
            				var emp = resData.empInfo;
            				let value = "";
            				    value += '<thead>'
                            		 	+		'<tr>'
                            		 	+	        '<th rowspan="2"><img id="profileImg" src="';
                            	
                            if(emp.empProfile != null){
                            	value +=  emp.empProfile;
                            }else{
                            	value += '${contextPath}/resources/images/defaultProfile.png';
                            }		 	
                            	value  +=			'" data-toggle="modal" onclick="' + "$('#profileModal').modal('show');\"" + '></th>'
                                		+			'<th align="left"><h5><b>'+ emp.name +'</b></h5></th>'                               
                                		+           '<th  align="right">'
                                    	+				'<a class="material-symbols-outlined aHover" style="text-decoration: none;" href="javascript:fn_goWrite(' + "'" + emp.email + "'" +')">mail</a>'
                                		+			'</th>'
                           				+		 '</tr>'                       
                        				+'</thead>'
                       					+'<tbody>'               
                            			+		'<tr>'
                                		+			'<td class="fontSmallSize">부서</td>'
                                		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ emp.deptName +'</td>'
                            			+		'</tr>'
                            			+		'<tr>'
                                		+			'<td class="fontSmallSize">직급</td>'
                                		+ 			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ emp.jobName +'</td>'
                            			+ 		'</tr>'
           								+		 '<tr>'
                                		+			'<td colspan="5"> <hr style="width: 100%;"> </td>'
                           				+ 		'</tr>'
                          				+		'<tr>'
			                       		+			'<td class="fontSmallSize">이메일</td>'
			                    		+			'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ emp.email+'</td>'
			                			+       '</tr>'
			                			+		'<tr>'

		                    		value += 	 '<tr>'
				                       	  +			'<td class="fontSmallSize">휴대전화</td>';
                           
                           if(emp.phone != null){
                        	   	var no = emp.phone;
       							var phone = no.slice(0,3) + '-' + no.slice(3, 8) + '-' + no.slice(8,11)
                        	   value += 			'<td colspan="4" class="fontMiddleAdd">&nbsp;&nbsp;' + phone + ' </td>';			               			  
                           }
                            			                    
                           		value	+=		'</tr>'
                           				+       '<tr>'
                                		+			'<td colspan="5"> <hr style="width: 97%;"> </td>'
                            			+		'</tr>'
			                            +		'<tr>'
                                		+			'<td class="fontSmallSize">입사일</td>'
                                		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ emp.joinDate+ '</td>'
                            			+		'</tr>'                             
                        				+'</tbody>'; 
                        				
                        	$("#beforeClick").remove();		
                        	$("#adDetailTb").html(value);
                        	$("#myAddChoiceArea").attr("style", "visibility:hidden; margin-left:30px;");
                        	                        	                        				
            			},
            			error:function(){
            				console.log("조직도 직원 상세보기 ajax 실패");
            			}
            		})
            	}
            	
            	function fn_goWrite(email) {
            		
            	  	var f = document.write_frm;
            	
            		f.setAttribute('method', 'post');
            	  	f.setAttribute('action', '${contextPath}/mail/write/new');
            	  
            	  	f.email.value = email;
            	
            	  	f.submit();
            	};
            	            	
            	// 내 연락처 목록클릭 시 조회 테이블
            	function selectAddTbList(addrGroupNo, page){
            		
            		var pageNo = 0;
            		if(page == null) {
            			pageNo = 1;
            		} else {
            			pageNo = page;
            		}
            		
            		$.ajax({
            			type: "post",
            			url : "${contextPath}/detail/myAddr/list",
            			data : { 
            				addrGroupNo: addrGroupNo,
            				page: pageNo
            			},            			
            			success : function(resData){
            				
            				let value="";
            					 value += '<table class="table" id="dataAddTable" addrGroupNo="'+ addrGroupNo + '">'
    	                               +	'<thead>'
    	                               +         '<tr>'
    	                               +				'<th style="width:10px"></th>'
    	                               +				'<th style="width: 10px;"></th>'
    	                               +				'<th>번호</th>'
    	                               +				'<th>이름</th>'
    	                               +				'<th>회사</th>'
    	                               +				'<th>이메일</th>'
    	                               +				'<th>팩스</th>'                
    	                               +				'<th>휴대전화</th>'      
                                	   +          '</tr>'                        
                                	   +    '</thead>'
                                	   +  '<tbody>'   ;                 						   
            					
            				let pageValue = "";
            				
            				let addrList = resData.addrList;
            				
            				if(addrList == null){
            					value += "<tr>"
            							+	"<td colspan='8'>등록된 연락처가 없습니다.</td>"            						
            							+"</tr>";
            				}else{
            					$.each(resData.addrList, function(i, addr){
            						value += 		'<tr>'
                                        	+ 			'<td><input type="checkbox" name="chk" value="'+ addr.personalNo  +'"></td>'
                                        	+			'<td>'
                                            +				'<span class="';
                                    if(addr.importantCheck == 'Y'){
                                    		value +=  'starYellow';
                                    }else{
                                    	value += 'starWhite';
                                    }     
                                            
                                     value  +=                '">★</span>'                           
                                        	+			'</td>'
                                        	+			'<td class="no">'+ addr.personalNo +'</td>'
                                        	+			'<td class="name">'+ addr.addrName +'</td>'
                                        	+			'<td>'+ addr.company +'</td>'
                                        	+			'<td>'+ addr.email +'</td>'
                                        	+			'<td>'+ addr.fax +'</td>'                                        	       
                                        	
                                        	if(addr.addrPhone != null){
                                        		 value   +=   '<td>'+ addr.addrPhone +'</td>';
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
                 					paging += '<button class="btn btn-sm btn-outline-primary" data-page="'+ (pageUtil.beginPage - 1) +'" onclick="selectAddTbList(' + addrGroupNo + ', '  + (pageUtil.beginPage - 1) + ')">◀</button>';
                 				}
                 				// 페이지번호
                 				for(let p = pageUtil.beginPage; p <= pageUtil.endPage; p++) {
                 					if(p == $('#page').val()){
                 						paging += '<strong>' + p + '</strong>';
                 					} else {
                 						paging += '<button class="btn btn-sm btn-outline-primary" data-page="'+ p +'" onclick="selectAddTbList(' + addrGroupNo + ', ' + p + ')>' + p + '</button>';
                 					}
                 				}
                 				// 다음 블록
                 				if(pageUtil.endPage != pageUtil.totalPage){
                 					paging += '<button class="btn btn-sm btn-outline-primary" data-page="'+ (pageUtil.endPage + 1) +'" onclick="selectAddTbList(' + addrGroupNo + ', ' + (pageUtil.endPage + 1) + ')>▶</button>';
                 				}
                 				$('#paging').append(paging);
            				}
            				
            				value   +=	'</tbody>'
                        			+ '</table>';
            				
            				$("#tableArea").html(value);
            				$(".pasingAdd").html(pageValue); 
            				            				            				
            				$("#addTitle").html("<h4><b>내 연락처</b></h4>");      
            				$("#deleteFeat").attr("style", "visibility:visible");
            				$("#cbx_chkAll").attr("style", "visibility:visible");
            				
            			},
            			error:function(){
            				console.log("내연락처 주소록 테이블 조회 ajax실패");
            			}       		
            		})
            	} 
            	
            	// 내연락처 & 별표연락처 상세보기
            	function selectDetailMyAdd(personalNo, addrGroupNo){
            		$.ajax({
            			url : "${contextPath}/my/addr/detail",
            			type:  "post",
            			data:{
            				personalNo:personalNo
            			},
            			success:function(resData){
            				let addr = resData.addr;
            				let value = "";
        				    value += '<thead>'
                        		 	+		'<tr>'
                        		 	+	        '<th class="Addstar">'
                        		 	+				'<input type="checkbox" name="importantCheck" value="Y" id="rate2" addrGroupNo="' + addrGroupNo + '"';
                        	if(addr.importantCheck == 'Y'){
                        	 value +=				'checked';
                        	}	 	
                        		 	
                        	value 	+=  			'><label for="rate2">★</label>'   
                        			+				'<input type="hidden" class="no" value="'+ addr.personalNo +'">'
                        		 	+			'</th>'
                            		+			'<th align="left"><h5><b>'+ addr.addrName +'</b></h5></th>';	
                             		+           '<th  align="right">'
                                	+				'<a class="material-symbols-outlined aHover" style="text-decoration: none;" href="selectEmail.ma?email='+ addr.email +'">mail</a>'
                            		+			'</th>'
                       				+		 '</tr>'                       
                    				+'</thead>';
                    				
                   			value	+= '<tbody>' 
                   					+		'<tr>'
			                        +           '<td class="fontSmallSize">회사</td>'
			                        +           '<td colspan="3" class="fontMiddleAdd">&nbsp;'+ addr.company +'</td>'
			                        +       '</tr>'		
                        			+		'<tr>'
                            		+			'<td class="fontSmallSize">그룹명</td>'
                            		+ 			'<td colspan="4" class="fontMiddleAdd">&nbsp; '+ addr.addrGroupName +'</td>'
                        			+ 		'</tr>'
       								+		 '<tr>'
                            		+			'<td colspan="5"> <hr style="width: 100%;"></td>'
                       				+ 		'</tr>'
                      				+		'<tr>'
		                       		+			'<td class="fontSmallSize">이메일</td>'
		                    		+			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ addr.email+'</td>'
		                			+       '</tr>';       			
	                      			
	                    		value += 	 '<tr>'
			                       	  +			'<td class="fontSmallSize">휴대전화</td>';
                       
                      	 if(addr.addrPhone != null){
                    	 	   value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp;' + addr.addrPhone + ' </td>';			               			  
                      	 }
		                       value +=		'</tr>'
		             			 	 + 	 	'<tr>'
			                       	 +			'<td class="fontSmallSize">FAX</td>';
                       	if(addr.fax != null){
                   	 	       value += 		'<td colspan="4" class="fontMiddleAdd">&nbsp;' + addr.fax + ' </td>';			               			  
                     	}            	 
                        			                    
                       		   value +=		'</tr>'
                       				 +       '<tr>'
                            		 +			'<td colspan="5"> <hr style="width: 97%;"> </td>'
                        			 +		'</tr>'
		                             +		'<tr>'
                            		 +			'<td class="fontSmallSize">메모</td>';
                            		
                          if(addr.memo != null ){
                        	  value += 			'<td colspan="4" class="fontMiddleAdd">&nbsp;'+ addr.memo+ '</td>';
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
	             				el.find("#personalNo").val(personalNo);
	             				el.find("#addrName").val(addr.addrName);
	             				el.find("#company").val(addr.company);
	             				el.find("#email").val(addr.email);
	             				el.find("#addrPhone").val(addr.addrPhone);
	             				el.find("#fax").val(addr.fax);
	             				el.find("#memo").val(addr.memo);	             				
	             			});
	             				             			
	             		});                      	
                                        	
            			},
            			error:function(){
            				console.log("내연락처 내 상세보기 ajax 실패");
            			}
            			
            		})
            	}
            	
            	// 별표연락처 테이블 조회            	            	
            	function selectStarAdd(page){
            	            		
            		var pageNo = 0;
            		if(page == null) {
            			pageNo = 1;
            		} else {
            			pageNo = page;
            		}
            	            		
            		$.ajax({
            			url: "${contextPath}/add/starList",
            			type: "post",
            			data: {
            				page:pageNo
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
                                    if(star.importantCheck == 'Y'){
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
            				console.log("중요연락처 조회 ajax실패")
            			}    
            		})
            	}
            	
            	// 별 클릭시 실시간 중요연락처 변경
            	function updateStarAdd(personalNo, importantCheck, addrGroupNo){
            		$.ajax({
            			url:"${contextPath}/change/important",
            			type: "post",
            			data: {
            				personalNo : personalNo,
            				importantCheck : importantCheck
            			},
            			success:function(resData){
            				if(resData.result == true){ 
            					
        						if($("#tableArea>table").is("#dataStarAddTable")){
        							// =>중요목록리스트 조회하는 ajax 호출
        							selectStarAdd();
        						}else{
        							selectAddTbList(addrGroupNo);
        						}
        						
        					}
            			},
            			error:function(){
            				console.log("실시간 중요연락처 변경 ajax 실패");
            			}
            		})
            		
            	}
            	
            	// 그룹 수정 ajax
            	function ajaxEditGp(){
            		let addrGroupNo =  $("#editGp #updateGpModalBd").find("#addrGroupNo").val();
            		let addrGroupName = $("#editGp table").find("#addrGroupName").val();
            		if(addrGroupName.trim() != 0 ){
            			$.ajax({
                			url: "${contextPath}/modify/group",
                			data:{
                				addrGroupNo:addrGroupNo,
                				addrGroupName:addrGroupName
                			},
                			success:function(resData){
                				if(resData.result == true){
                					// 처리 후 모달창 닫기
                					$('#editGp').modal('hide');
                					selectGpList(); 
                				}
                			},
                			error:function(){
                				console.log("그룹수정 ajax실패");
                			}
                		})
            		}else{
            			alert("그룹이름을 입력해주세요.");
            		}
            	}
            	
            	// 그룹등록용 ajax
            	function ajaxAddGp(){
            		let employeeNo = $("#addGpTb").find("#empNo").val();
            		let addrGroupName = $("#addGpTb").find("#addrGroupName").val();
            		if(addrGroupName.trim() != 0 ){
            			$.ajax({
                			url:"${contextPath}/add/addr/group",
                			data:{
                				addrGroupName:addrGroupName
                			},
                			success:function(resData){
                				if(resData.result == true){
                					// 처리 후 모달창 닫기 + 비워주기
                					$("#addGpTb").find("#addrGroupName").val("");
                					$('#addGp').modal('hide');
                					selectGpList(); 
                				}
                			},
                			error:function(){
                				console.log("그룹등록 ajax 실패");
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
						let personalNo = $("#adDetailTb .no").val(); 
						$.ajax({
							type : 'post',
							url:"${contextPath}/delete/myAddr",
							traditional:true,
							data:{ personalNo:personalNo
							},
							success:function(resData){
								if(resData.result == true){
                    				
                    				// 각각의 테이블 조회하는 ajax 호출
                    				if($("#tableArea>table").is("#dataStarAddTable")){                					
                    					selectStarAdd();
                    				}else{
                    					let addrGroupNo = $("#dataAddTable").attr("addrGroupNo");
                    					//console.log(groupNo);
                    					selectAddTbList(addrGroupNo);
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
                			type : 'post',
                    		url : "${contextPath}/delete/checked/myAddr",
                    		// ajax에서 배열의 값을 java단으로 넘기고 싶을땐 꼭해줘야함!!
                    		traditional:true,
                    		data : {
                    			personalNo:arr
                    		},
                    		success:function(resData){
                    			if(resData.result == true){
                    				
                    				// 각각의 테이블 조회하는 ajax 호출
                    				// 지금 테이블이 별표연락처라면 삭제 후 다시 별표연락처를 조회하도록
                    				if($("#tableArea>table").is("#dataStarAddTable")){                					
                    					selectStarAdd();
                    				}else{
                    					let addrGroupNo = $("#dataAddTable").attr("addrGroupNo");
                    					//console.log(groupNo);
                    					
                    					// 다시 조회
                    					selectAddTbList(addrGroupNo);     
                    					
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
		
<%@ include file="../layout/footer.jsp" %>