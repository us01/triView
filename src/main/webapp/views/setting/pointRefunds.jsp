<%@page import="com.chain.triangleView.member.member.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%
	Member loginUser = (Member)session.getAttribute("loginUser");
        %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="/triangleView/js/jquery-3.3.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<script src="https://code.jquery.com/color/jquery.color-2.1.2.js"
	integrity="sha256-1Cn7TdfHiMcEbTuku97ZRSGt2b3SvZftEIn68UMgHC8="
	crossorigin="anonymous">
</script>
<style>
.containChange {
	width: 670px;
	height: 600px;
	text-align: left;
	font-size: 13px;
	float: right;
	margin-right: -210px;
}

.btn-success {
	background-color: #f8585b;
	border: none;
	color: #FDEBEC;
	text-align: center;
	text-decoration: none;
	cursor: pointer;
	border-radius: 5px;
}

.profileOut {
	width: 100px;
	height: 100px;
	border-radius: 100px;
	margin-left: -120px;
	margin-top: 100px;
}

.containRefunds{
	margin-top: -120px;
}

</style>
</head>
<body>
	<form class="changeForm" id="form" name="pointRefunds" action="" method="post">
		<div class="containChange">
			<div style="margin-top: 200px;">
				<img class="profileOut" id="image_section"
					src="<%=request.getContextPath()%>/thumbnail_upload/<%=loginUser.getThumbnail() %>"/>
			</div>	
			
			<input type="hidden" value="<%=loginUser.getUserNo()%>" name="userNo">
			
			<div class="containRefunds">
				<div>
					<span class="" style="background-color: white; color: black;" readonly>보유포인트</span>
					<div>
						<input type="text" class="" id="myPoint" name="myPoint"
							placeholder="보유포인트" style="width: 270px;" value="<%=loginUser.getPoint()%>">
					</div>
				</div>
				<div>
					<span class="" style="background-color: white; color: black;">환급포인트</span>
					<div>
						<input type="text" class="" id="refundPoint" name="refundPoint"
							placeholder="환급포인트" style="width: 270px;" >
					</div>
				</div>

				
				
				<div>
					<span class="" style="background-color: white; color: black;">
						환급금액</span>
					<div>
						<input type="text" class="" id="refundMoney" 
							name="refundMoney" placeholder="환급금액" style="width: 270px;" readonly>
						
					</div>
				</div>
			</div>
			<div class="" style="text-align: center; height: 40px; margin-top: 10px; display: inline-block;">
				<input type="button" class="btn-success" id="updatePoint" 
					value="환급신청" disabled="disabled" onclick="youHaveTo()"></input>
				<input type="reset" class="btn-success" onclick="end();" value="취소"></input>
			</div>
		</div>
	</form>
	
					<script>
				$(document).ready(function() {
					$("#myPoint").keyup(function() {
						$(this).val($(this).val().replace(/[^0-9]/g, ""));
					});
					
					$("#refundPoint").keyup(function() {
						$(this).val($(this).val().replace(/[^0-9]/g, ""));
					});

				});
					$("#refundPoint").keyup(function(){
						var point1 = <%=loginUser.getPoint()%>;
						
						var point2 = document.getElementById("refundPoint").value;
						var result = point1-point2;
						if(result >= 0){
						document.getElementById("myPoint").value = result;	
						document.getElementById("refundMoney").value = point2 + "원";
						$('#updatePoint').attr("disabled", false);
						}else if(result < 0){
						alert("환급 포인트가 기존 포인트를 초과합니다! 값을 다르게 입력해주세요!");
						$(this).select();
						$('#updatePoint').attr("disabled", true);	
						}else{
							alert("숫자만 입력 가능합니다!");
						}
						
					});
					
					function youHaveTo(){
						
						theForm = document.pointRefunds;
						var form = document.getElementById("form");
						form.action = "<%=request.getContextPath() %>/pointRefunds.me"; 
						form.submit();
					}
				</script>
				
				
</body>
</html>