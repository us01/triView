<%@page import="com.chain.triangleView.member.member.vo.Member"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.chain.triangleView.review.review.vo.RwComment"%>
<%@page import="com.chain.triangleView.review.review.vo.Form"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Member loginUser = (Member)session.getAttribute("loginUser");
	HashMap<String, Object> reviewForm = (HashMap<String, Object>)request.getAttribute("reviewForm");

	Iterator<String> keys = reviewForm.keySet().iterator();
	Form form = null;
	ArrayList<RwComment> rwComment = null;
	
	int rwNo = -1;
	
	while(keys.hasNext()){
		String key = keys.next();
		if(key.equals("form")){
			form = (Form)reviewForm.get(key);
			rwNo = form.getRwNo();
		}else if(key.equals("rwComment")){
			rwComment = (ArrayList<RwComment>)reviewForm.get(key);
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="/triangleView/js/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" href="/triangleView/css/w3.css">
<link rel="stylesheet" href="/triangleView/css/reviewForm.css">
<script
	src="https://code.jquery.com/color/jquery.color-2.1.2.js"
	integrity="sha256-1Cn7TdfHiMcEbTuku97ZRSGt2b3SvZftEIn68UMgHC8="
	crossorigin="anonymous">
</script>
<script>
	function subSiteMove(subSite){
		$(location).attr('href', subSite);
	}
	
	function modifyMove(){
		
	}
	
	function likeThis(rwNo){
		$.ajax({
			url : '<%= request.getContextPath() %>/likeReview',
			type : 'get',
			data : {
				rwNo : rwNo
			},
			success : function(data){
				if(data == 1){
					$('.like-qty span').text(<%= form.getRwLikeCount() + 1 %>);
					$('.like-qty img').attr('src', '/triangleView/img/reviewForm/love.png');
					$('.like-qty img').removeAttr('onclick');
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="subTopArea"> 
		<% if(form.getRwType() != 0){ %>
			<p>기업 후원을 받은 리뷰입니다.</p>
		<% } %>
	</div>
	<div class="review-Form">
		<div class="contentArea">
			<%= form.getRwContent() %>
		</div>
		<div class="contentInfoArea">
			<div>
				<div class="contentinfo-header">
					<div class="reviewProfileImageArea">
						<img src="/triangleView/profileImg_upload/<%= form.getThumbnail() %>">
					</div>
					<div class="reviewTitleArea">
						<p><%= form.getRwTitle() %></p>
						<br>
						<p>@<%= form.getNick() %></p>
						<p><%= form.getWriteDate() %></p>
						<div class="starArea">
							<span class="star-input">
								<span class="input">
									<% 
										int grade = form.getRwGrade();
								
										for(int i = 0; i < 11; i++){ %>
										<% if(i == grade ){ %>
											<input type="radio" name="star-input" id="star<%= i %>" disabled checked><label for="star<%= i %>"></label>
										<% }else{ %>
											<input type="radio" name="star-input" id="star<%= i %>" disabled><label for="star<%= i %>"></label>
										<% } %>
									<% } %>
								</span>
							</span>
						</div>
					</div>
				</div>
				<div class="contentinfo-body">
					<div class="reviewSideContent">
						<%= form.getRwComment() %>
					</div>
					<div class="comment-qty">
						<img src="/triangleView/img/reviewForm/view.png">
						<span><%= form.getRwCommentCount() %></span>
					</div>
					<div class="like-qty">
						<% if(loginUser != null && (form.getLikeMe() == 0)){ %>
							<img src="/triangleView/img/reviewForm/nolove.png" onclick="likeThis(<%= form.getRwNo() %>)">
						<% }else{ %>
							<img src="/triangleView/img/reviewForm/love.png">
						<% } %>
						<span><%= form.getRwLikeCount() %></span>
					</div>
				</div>
				<!--코멘트  -->
				<div class="rwCommentArea">
					<% if(rwComment != null){ %>
						<jsp:include page="./commentsForm.jsp" flush="true">
							<jsp:param name="reviewForm" value="<%= reviewForm %>"/>
						</jsp:include>
					<% } %>
				</div>
			</div>
		</div>
		<div class="subSideArea">
			<% if(form.getRwType() != 0){ %>
				<button onclick="subSiteMove('<%= form.getCoorLink() %>')">관련 링크</button>
			<% }else{ %>
				<% if(loginUser.getUserType() == 1){ %>
					<button onclick="subSiteMove('<%= form.getRwNo() %>, <%= loginUser.getUserNo() %>')">제휴 걸기</button>
				<% } %>
			<% } %>
			<% if(loginUser.getNick().equals(form.getNick())){ %>
				<button onclick="modifyMove('<%= form.getRwNo() %>')">수정</button>
			<% } %>
		</div>
	</div>
</body>
</html>