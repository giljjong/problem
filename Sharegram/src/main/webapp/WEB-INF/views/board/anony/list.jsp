<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- <jsp:include page="../layout/header.jsp">
	<jsp:param value="그룹웨어메인" name="title" />
</jsp:include> --%>

<script>
$(function(){
	fn_searchList();
	// 자료실용 fn_uploadList();
	fn_allList();
	fn_write();
})
	/* 자료실용
		function fn_uploadList(){	
			$.ajax({	
				type : 'get',
				url : '${contextPath}/upload/ulist',
				dataType: 'json',
				data : 'pageNo=' + ${pageNo} ,
				success: function(resData){
					$('#paging').empty();
					$('#result').empty();
					$.each(resData.uploadList, function( i , uploadList){
						$('<tr>')
						.append( $('<td class="content_line center_font">').text(uploadList.uploadBoardNo) )
						.append( $('<td class="content_line">').append( $('<a>').text(uploadList.uploadTitle).attr('href' ,'${contextPath}/upload/incrase/hit?uploadBoardNo=' + uploadList.uploadBoardNo ) ) )
						.append( $('<td class="content_line center_font">').text(uploadList.createDate) )
						.append( $('<td class="content_line center_font">').text(uploadList.attachCnt) )
						.append( $('<td class="content_line center_font">').text(uploadList.ip) )
						.append( $('<td class="content_line center_font">').text(uploadList.hit) )
						.appendTo('#result');	
					
					})	
					
					var str = '' ;	
			 	    if(resData.beginPage != 1){
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.beginPage -1) + '>' + '◀' + '</a>';
					}  
				 	for(let p = resData.beginPage; p <= resData.endPage; p++){
					 	if(p == resData.page){
					 		str += '<strong>' + p + '</strong>' ;
						}  
						else {
							str += '<a href=${contextPath}/upload/list?pageNo=' + p +'>'+ p + '</a>';
						} 
					} 
					if(resData.endPage != resData.totalPage) {
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.endPage + 1) + '>' + '▶' + '</a>';
						console.log(str);
					}     
					 
					   
					 $('#paging').append(str);   	
				},
				error: function(jqXHR){
					alert('리스트 불러오기가 실패했습니다.');
				}
		})
	} */
	
	function fn_searchList(){
		$('#btn_search').click(function (){
			$.ajax({
				type : 'get',
				url : '${contextPath}/board/anony/search',
				data : 'pageNo=' + ${pageNo} + '&column=' + $('#column').val() + '&query=' + $('#query').val(),
				dataType : 'json',
				success : function (resData){
					console.log(resData)
					$('#paging').empty();
					$('#result').empty();
					
					$.each(resData.anonyList, function( i , anonyList){
						$('<tr>')
						.append( $('<td class="content_line center_font">').text(anonyList.anonyNo) )
						.append( $('<td class="content_line center_font">').text(anonyList.anonyEmpNo) )
						//.append( $('<td class="content_line">').append( $('<a>').text(anonyList.anonyTitle).attr('href' ,'${contextPath}/board/anony/incrase/hit?anonyBoardNo=' + anonyList.anonyBoardNo ) ) )
						.append( $('<td class="content_line center_font">').text(anonyList.anonyCreateDate) )
						
						.append( $('<td class="content_line center_font">').text(anonyList.hit) )
						.appendTo('#result');	
					
					})	
					
					/* 	pageutil 통해 페이징 처리 예정			
					var str = '' ;	
			 	    if(resData.beginPage != 1){
						str += '<a href=${contextPath}/board/anony/list?pageNo=' + Number(resData.beginPage -1) + '>' + '◀' + '</a>';
					}  
				 	for(let p = resData.beginPage; p <= resData.endPage; p++){
					 	if(p == resData.page){
					 		str += '<strong>' + p + '</strong>' ;
						}  
						else {
							 str += '<a href=${contextPath}/board/anony/search?pageNo=' + p + '&column=' + resData.column + '&query=' + resData.query  + '>'+ p + '</a>'; 
						} 
					} 
					if(resData.endPage != resData.totalPage) {
						str += '<a href=${contextPath}/board/anony/list?pageNo=' + Number(resData.endPage + 1) + '>' + '▶' + '</a>';
						console.log(str);
					}    */  
					 
					   
					 $('#paging').append(str);   	
				},
				error: function(jqXHR){
					alert('리스트 불러오기에 실패했습니다.');
				
				} 
			})
		})		
	}
	
	function fn_allList(){
		$('#btn_all').click(function (){
			fn_anonyList();	
		})
	}
	
	function fn_write(){
		$('#btn_write').click(function (){
			location.href = '${contextPath}/board/anony/write';
		})
	}
	
	// 페이징 처리
	$(function(){
		$('#btn_write').click(function (){
			location.href = '${contextPath}/board/anony/write';
		})
		
		$('#btn_first').click(function (){
			location.href = '${contextPath}/board/anony/list';
		})
		// 5개 목록씩 보기
		if('${recordPerPage}' != ''){
			$('#recordPerPage').val(${recordPerPage});			
		} else {
			$('#recordPerPage').val(5);
		}
		
		$('#recordPerPage').change(function(){
			location.href = '${contextPath}/board/anony/list?recordPerPage=' + $(this).val();
		});
		
	});
	
	
	/* 공시사항용 
	// 게시글 전체 선택
   	$("#anonyeList").on("click", "#checkAll", function(){
   		$("input[id^=checkNo]").attr("selected", true);
   		if($("#checkAll").is(":checked")){
   			$("input[name=chkanonyNo]").prop("checked", true);
   		}else{
   			$("input[name=chkanonyNo]").prop("checked", false);
   		}
   	}) 
   	
   	// -----------체크박스 선택하면 값 가져오기-----------
   	$("input[name=chkanonyNo]").click(function(){
        var count = $("input[name='chkanonyNo']").length;
        var checked = $("input[name='chkanonyNo']:checked").length;
        
        // 체크한 체크박스의 개수와 전체 체크박스 개수가 같으면 전체 선택 체크박스가 체크된다.
        if(count != checked){
            $("#checkAll").prop("checked", false);
        } else{
            $("#checkAll").prop("checked", true);
        }
        
    });
   	
   	let checkList = "";
   	// 체크박스 선택시 값 가져오기
   	$("input[type=checkbox]").change(function(){
   		checkList = ""; // 여기서 한번 비워서 중복요소 제거
   		$("input:checkbox[name=chkanonyNo]:checked").each(function(){
   			checkList += ($(this).val()) + ",";
   		})
			//console.log(checkList);
			checkList = checkList.substring(0,checkList.lastIndexOf(",")); // 맨 뒤 콤마 불요
   	})
   	
   	// 공지 설정 ajax처리
	function goTop(isYN){
   		//console.log(checkList);
   		// isYN : 1 -> 공지 등록, 2-> 공지 해제
			$.ajax({
				url:"anonyTop.no",
				data:{
					checkList:checkList,
					isYN:isYN
				},
				success(result){
					alert("공지 등록/해제 처리 되었습니다");
					location.reload();
				},error(){
					console.log("ajax통신 실패");
				}
			})
   	}
   	*/
</script>

	<div class="anonybrd">
		<div class="brd_anony">
			<div class="anonyHeader">
				<div>
				<h2>익명게시판</h2>
					<div class="board_anony">
						<!-- (하단으로 이동 예정) -->
						<div>
							<button id="btn_write" class="btn_primary" onclick="location.href='${contextPath}/board/anony/write'">게시글작성</button>

							<button id="btn_first" class="btn_primary" onclick="location.href='${contextPath}/board/anonyList'">첫페이지로</button>
						</div>
						
						<div>
							<form id="frm_search" action="${contextPath}/board/anony/search">
								<select id="column" name="column" class="select">
									<option value="">::선택::</option>
									<option value="BOARD_TITLE">제목</option>
								</select>
								
								<span id="area1">
									<input type="text" id="query" name="query" class="input searchBox">
								</span>
				
								<span>
									<input type="button" value="검색" id="btn_search" class="btn_primary">
									<input type="button" value="전체조회" id="btn_all" class="btn_primary"> 
								</span>
							</form>
							
							<select id="recordPerPage">
								<option value="5">5</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
							</select>
					
						</div>
						
						<hr>
				
				<div class="anonyList">
					<table class="anonyBoard">
						<thead class="brd_thead">
							<tr class="brd_thead_name">
								<th width="5%">번호</th>	
								<th width="30%">글제목</th>
								<th width="8%">작성일</th>
								<th width="8%">작성자</th>	<!-- 순서 확인 -->
								<!-- <th width="5%"></th> -->
							</tr>
						</thead>
						<tbody class ="anony-tbody">
							<c:if test="${ empty list }">
	                        		<tr>
	                        			<td colspan="6">등록된 게시글이 없습니다.</td>
	                        		</tr>
	                        	</c:if>
	                        	<c:forEach var="n" items="${list}">
		                        	<c:if test="${ a.boardTop eq 'Y'}">
				                        <tr style="background:rgb(250, 232, 232)">	<!-- 익명만 다른 컬러 혹은 게시판별 색상 변경 예정 -->
				                            <td class="no">${ a.anonyNo }</td>
				                            <td><a href="${contextPath}/board/anony/detail?anonyNo=${ a.anonyNo }">${ a.anonyTitle }</a></td>
				                            <td>${ a.createDate }</td>
				                            <td>${ a.anonyEmpNo }</td>
				                           <%--  <td>
												<form method="post" action="${contextPath}/anony/remove">	<!-- data속성 : date-(-뒤에는 자유롭게 작성) -->
													<input type="hidden" name="anonyNo" value="${ a.anonyNo }">
													
													
													<a class="lnk_remove" id="lnk_remove${ a.anonyNo }">
														<center><i class="fa-sharp fa-solid fa-trash fa-sm"></i></center>
													</a>
													
												</form>
												<script>
													$('#lnk_remove${ a.anonyNo }').click(function(){
														if(confirm('해당 글을 삭제하시겠습니까? 데이터 삭제시 복구가 불가능합니다.')){
															$(this).parent().submit();
														}		
													});
												</script>
											</td> --%>
				                        </tr>
		                        	</c:if>
				                </c:forEach>
	                        	<%-- <c:forEach var="n" items="${list}">
			                        <c:if test="${ a.boardTop eq 'N'}">
				                        <tr>
				                            <td class="no">${ a.boardNo }</td>
				                            <td>${ a.anonyTitle }</td>
				                            <td>${ a.anonyCreateDate }</td>
				                            <td>${ a.anonyEmpNo }</td>
				                        </tr>
			                        </c:if>
			                    </c:forEach> --%>
	                    </tbody>
						<tfoot>
							<tr>
								<td colspan="4" id="paging" >
								
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
				
			</div>
		</div>
	</div>
	</div>
</div>
</body>
</html>