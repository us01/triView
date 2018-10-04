package com.chain.triangleView.notice.notice.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;

import static com.chain.triangleView.common.JDBCTemplate.*;

import com.chain.triangleView.allian.allian.dao.AllianDao;
import com.chain.triangleView.allian.allian.vo.AllianData;
import com.chain.triangleView.notice.notice.dao.NoticeDao;
import com.chain.triangleView.notice.notice.vo.notice.Application;
import com.chain.triangleView.notice.notice.vo.notice.Attachment;
import com.chain.triangleView.notice.notice.vo.notice.Notice;
import com.chain.triangleView.notice.notice.vo.notice.ProductService;

import static com.chain.triangleView.common.JDBCTemplate.*;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;

import com.chain.triangleView.notice.notice.dao.NoticeDao;
import com.chain.triangleView.notice.notice.vo.notice.Notice;

public class NoticeService {

	public ArrayList<HashMap<String, Object>> selectAllNotice() {
		
		Connection con = getConnection();
		ArrayList<HashMap<String, Object>> noticeList = new NoticeDao().selectAllNotice(con);
		
		close(con);
		
		return noticeList;
		
	}

	public ArrayList<HashMap<String, Object>> selectCurrNotice() {
		
		Connection con = getConnection();
		ArrayList<HashMap<String, Object>> noticeList = new NoticeDao().selectCurrNotice(con);
		
		close(con);
		
		return noticeList;
	}
	
	public int[] insertAttachment(ArrayList<Attachment> fileList, Notice n, ProductService p) {
		Connection con = getConnection();
		int result[] = {0, 0};
		//상품(종류) 인설트
		int result3 = new NoticeDao().insertProduct(con,p);

		if(result3 > 0){
			commit(con);

		}
		else{
			System.out.println("상품인서트 실패!");
		}

		//상품 코드를 받자
		int productNo = new NoticeDao().productNocheck(con);


		//받아온 상품 코드를 객체에 넣어준다
		p.setProductNo(productNo);


		//받아온 상품명을 가지고 상품 서비스 인서트 하러간다.

		int result4 = new NoticeDao().insertService(con,p);

		//전부 대입한후에 서비스 정보를 인서트 한다.
		if(result4 > 0){
			commit(con);
			System.out.println("서비스 인서트 성공!!");
		}else{
			System.out.println("두번째 인서트 실패!!");
		}


		//서비스번호를 알기위해서 한번더 간다.
		int serviceNo = new NoticeDao().serviceNocheck(con);

		n.setServiceNo(serviceNo);
		result[1] = serviceNo;




		//공고 인서트 하러갑시다.
		int result1 = new NoticeDao().insertNotice(con,n);

		if(result1 >0){

			commit(con);


		}
		int noticeCode = new NoticeDao().noticeNocheck(con);

		for(int i= 0; i < fileList.size(); i++){
			fileList.get(i).setNoticeCode(noticeCode);

		}


		//파일 인서트 문제없음
		int result2 = new NoticeDao().insertAttachment(con, n, fileList);

		if(result2 >0){
			commit(con);
			result[0] = 1;


		}else{
			rollback(con);
		}

		close(con);

		return result;
	}

	public ArrayList<Notice> selectList() {
		Connection con = getConnection();
		ArrayList<Notice> list = null;




		list = new NoticeDao().selectList(con);


		return list;
	}

	public ArrayList<Notice> categorySelect(int categoryCode) {
		Connection con = getConnection();
		ArrayList<Notice> list = null;

		list = new NoticeDao().categorySelect(categoryCode,con);


		return list;
	}


	public HashMap<String, Object> loadNoticeFrom(int noticeNo) {
		Connection con = getConnection();

		HashMap<String,Object> noticeForm = null;


		ArrayList<Application> a = new ArrayList<Application>();


		a = new NoticeDao().loadOneForm(con,noticeNo);


		if(a != null){
			ArrayList<Notice> list = new NoticeDao().detailsList(con,noticeNo);

			noticeForm = new HashMap<String,Object>();

			noticeForm.put("a", a);
			System.out.println("a는 담겼닝?" + a);
			noticeForm.put("list", list);
			System.out.println("list는 담겼닝??" + list);
		}else{
			System.out.println("hashmap 담기실패!!");
		}




		return noticeForm;
	}


	public int insertApplication(int noticeCode, int noticeWriter) {
		Connection con = getConnection();
		int result = 0 ;

		result = new NoticeDao().insertApplication(con,noticeCode,noticeWriter);


		if(result > 0){
			commit(con);
			System.out.println("공고신청성공!!");
		}else{
			System.out.println("공고신청실패!!");
		}

		close(con);


		return result;
	}

	public HashMap<String, Object> loadNoticeAllianFrom(int noticeWriter) {
		Connection con = getConnection();

		HashMap<String,Object> noticeAllianForm = null;


		ArrayList<Notice> list = new ArrayList<Notice>();

		list = new NoticeDao().selectNoticePage(con,noticeWriter);

		if(list != null){
			ArrayList<AllianData> list1 = new AllianDao().selectAllianPage(con,noticeWriter);

			ArrayList<Notice> list3 = new NoticeDao().selectMainImg(con,noticeWriter);

			ArrayList<Notice> list4 = new ArrayList<Notice>();

			list4 = new NoticeDao().selectNoticeNPage(con,noticeWriter);

			noticeAllianForm =new HashMap<String,Object>();

			noticeAllianForm.put("list", list);
			noticeAllianForm.put("list1", list1);
			noticeAllianForm.put("list3", list3);
			noticeAllianForm.put("list4", list4);
		}
		
		close(con);


		return noticeAllianForm;
	}

	public ArrayList<Notice> selectNoticeOneList(int noticeWriter) {
		Connection con = getConnection();
		ArrayList<Notice> list1 = new ArrayList<Notice>();
		int noticeCode = 0;

		//공고 시퀀스 코드를 조회하기 위해 간다.

		noticeCode = new NoticeDao().selectNoticeCheckCode(con);

		System.out.println("서비스 noticeCode가뭐니???" + noticeCode);

		//글작성한 한명의 데이터 정보,사진등을 가져오기위해 간다
		list1 = new NoticeDao().selectNoticeOneList(con,noticeWriter,noticeCode);






		return list1;
	}

	public int updateNoticeY(int noticeCode, int userNo) {
		Connection con = getConnection();
		int result = 0;

		result = new NoticeDao().updateNoticeY(con,noticeCode,userNo);

		if(result > 0){
			commit(con);
			System.out.println("성공적으로 인서트");
		}else{
			System.out.println("실패!!");
		}

		close(con);

		return result;
	}

	public HashMap<String, Object> loadNoticeDetailsForm(int noticeNo) {
		Connection con = getConnection();
		HashMap<String,Object> loadNoticeDetailsForm = null;
		ArrayList<Notice> list = null;
		ArrayList<Application> list1 = null;
		ArrayList<Application> list2 = null;

		int result = new NoticeDao().UpdateCount(con,noticeNo);


		if(result > 0){

			commit(con);

			loadNoticeDetailsForm = new HashMap<String,Object>();

			list = new NoticeDao().detailsList(con,noticeNo);

			list1 = new NoticeDao().selectNoticeN(con,noticeNo);

			list2 = new NoticeDao().selectNoticeY(con,noticeNo);

			loadNoticeDetailsForm.put("list", list);

			System.out.println("list:" + list);

			loadNoticeDetailsForm.put("list1", list1);

			System.out.println("list1" + list1);
			loadNoticeDetailsForm.put("list2", list2);

			System.out.println("list2" + list2);
		}else{
			System.out.println("잘못되었음");
		}

		close(con);

		return loadNoticeDetailsForm;
	}
}
