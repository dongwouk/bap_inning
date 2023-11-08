package com.app.dao;

import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.app.dto.MemberDTO;

@Repository
public class MemberDAO {
	@Autowired
	SqlSessionTemplate session;

	
		//id 중복체크
		public MemberDTO idCheck(String userid) {
			MemberDTO dto = session.selectOne("MemberMapper.idCheck", userid);
			return dto;
		}
		
		//닉네임 중복체크
		public MemberDTO nicknameCheck(String nickname) {
		    MemberDTO dto = session.selectOne("MemberMapper.nicknameCheck", nickname);
			return dto;
		}
		
		// 회원가입
		public int memberAdd(MemberDTO dbdto) {
			int n = session.insert("MemberMapper.memberAdd", dbdto);
			return n;
		}
		//로그인
		public MemberDTO login( HashMap<String, String> map) {
			MemberDTO dbdto = session.selectOne("MemberMapper.login", map);
			return dbdto;
		}
		
		
		
		
		//mypage
		public MemberDTO getMypage( String userid) {
			MemberDTO dbdto = session.selectOne("MemberMapper.mypage", userid);
			return dbdto;
		}
		
		
		public int updateTemporaryPW(HashMap<String, String> map) {
			return session.update("MemberMapper.updateTemporaryPW", map);
		}
		
		public String findEncodePW(HashMap<String, String> map) {
			return session.selectOne("MemberMapper.findEncodePW", map);
		}
	
		
		// 비밀번호 현황 판단
	    public MemberDTO getPasswdStatus(HashMap<String, String> map) {
	    	MemberDTO dto = session.selectOne("MemberMapper.getPasswdStatus", map);
			return dto;
		}
	
	    // 임시비밀번호 재설정
	    public int resetPassword(HashMap<String, String> hashmap) {
			int n=session.update("MemberMapper.resetPassword",hashmap);
			return n;
		}
}
