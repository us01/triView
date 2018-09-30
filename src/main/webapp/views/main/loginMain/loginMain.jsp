<%@page import="com.chain.triangleView.member.member.vo.MemberInterestCategory"%>
<%@page import="com.chain.triangleView.review.review.vo.Review"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.chain.triangleView.member.member.vo.Member, com.chain.triangleView.notice.notice.vo.notice.Notice, java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Member loginUser = (Member)session.getAttribute("loginUser");
	ArrayList<MemberInterestCategory> loginUserInterestCategory = (ArrayList<MemberInterestCategory>)session.getAttribute("loginUserInterestCategory");
	ArrayList<Review> interestReviewList = (ArrayList<Review>)request.getAttribute("interestReviewList");
	ArrayList<Review> searchReviewList = (ArrayList<Review>)request.getAttribute("searchReviewList");
	Member followCountMember = (Member)request.getAttribute("followCountMember");
	String searchData = "default";
	
	ArrayList<HashMap<String, Object>> noticeList = (ArrayList<HashMap<String, Object>>)request.getAttribute("selectAllNotice");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="/triangleView/js/jquery-3.3.1.min.js"></script>
<script
	src="https://code.jquery.com/color/jquery.color-2.1.2.js"
	integrity="sha256-1Cn7TdfHiMcEbTuku97ZRSGt2b3SvZftEIn68UMgHC8="
	crossorigin="anonymous">
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>세모뷰 로그인 후/리뷰 리스트</title>
<style>
	body {
		margin:0px;
		background:#fafafa;
		font-family:'맑은고딕';
	}
	.centents{
		margin:0 auto;
		width:1000px;
		margin-top:70px;
		padding-left:50px;
		padding-right:50px;
	}
	.reviewListArea {
		margin:0 auto;
		display:inline-block;
		width:696px;
	}
	.write img{
		display:inline-block;
		margin:0 auto;
		width:50px;
		height:50px;
	}
	.uploadViewAear {
		z-index: 300;
   		position: absolute;
   		left: 50%;
   		margin-left:-250px;
    	top: 150px;
	}
	@media all and (max-width:768px) {
		.centents {
			width:100%;
			padding-left:0px;
			padding-right:0px;
		}
		.write img{
			margin-top:10px;
			margin-left:10px;
		}
	}
</style>
<script>
	function ploadViewAearAreaDisplayNone() {
		document.getElementById('uploadViewAear').style.display = 'none';
		document.getElementById('uploadViewAearArea').style.display = 'none';
	}
	
	$(function(){
		$("#searchReviewInput").keypress(function(key) {
			if(key.which == 13){
				var searchHash = $("#searchReviewInput").val();
				var searchData = $("#searchReviewInput").val();
				$.ajax({
					url : '<%= request.getContextPath()%>/reSearchReview.sr',
					data : {
						searchHash:searchHash,
						searchData:searchData
					},
					type : 'post',
					success : function(data) {
						$(".reviewListArea").html(data);
					}
				});
			}
		});
	})
</script>
</head>
<body>
	<jsp:include page="../header/headerNav.jsp" flush="true"/>
	<div class="centents">
		<jsp:include page="./leftContent.jsp" flush="true">
			<jsp:param name="followCountMember" value="<%= followCountMember %>"/>
			<jsp:param name="loginUserInterestCategory" value="<%= loginUserInterestCategory %>"/>
		</jsp:include>
		<div class="reviewListArea">
			<% if(interestReviewList != null){ %>
				<jsp:include page="./centerContent.jsp" flush="true">
					<jsp:param name="interestReviewList" value="<%= interestReviewList %>"/>
				</jsp:include>
			<% }else { %>
				<jsp:include page="../../searchReviewList/searchReviewList.jsp" flush="true">
					<jsp:param name="searchReviewList" value="<%= searchReviewList %>"/>
				</jsp:include>
			<% } %>
		</div>
		<jsp:include page="./rightContent.jsp" flush="true">
			<jsp:param name="noticeAllList" value="<%= noticeList %>"/>
		</jsp:include>
	</div>
</body>
</html>