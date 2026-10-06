package com.clubsphere.service;

import com.clubsphere.dao.ClubDAO;
import com.clubsphere.dao.ClubMemberDAO;
import com.clubsphere.model.Club;
import com.clubsphere.model.ClubMember;

import java.util.List;

public class ClubService {
    private final ClubDAO clubDAO = new ClubDAO();
    private final ClubMemberDAO clubMemberDAO = new ClubMemberDAO();

    public List<Club> getAllClubs() {
        return clubDAO.findAll();
    }

    public Club getClubById(int id) {
        return clubDAO.findById(id);
    }

    public Club getClubByCode(String code) {
        return clubDAO.findByCode(code);
    }

    public Club getClubByHeadUserId(int headUserId) {
        return clubDAO.findByHeadUserId(headUserId);
    }

    public boolean createClub(Club club) {
        return clubDAO.create(club);
    }

    public boolean updateClub(Club club) {
        return clubDAO.update(club);
    }

    public boolean assignHead(int clubId, Integer headUserId) {
        return clubDAO.assignHead(clubId, headUserId);
    }

    public boolean updateStatus(int clubId, String status) {
        return clubDAO.updateStatus(clubId, status);
    }

    public List<Club> searchClubs(String keyword, String category) {
        return clubDAO.searchClubs(keyword, category);
    }

    public List<ClubMember> getClubMembers(int clubId) {
        return clubMemberDAO.findByClubId(clubId);
    }

    public List<ClubMember> getUserClubs(int userId) {
        return clubMemberDAO.findByUserId(userId);
    }

    public boolean isMemberOfClub(int userId, int clubId) {
        return clubMemberDAO.isMemberOfClub(userId, clubId);
    }

    public boolean addMember(int clubId, int userId, String memberRole, String notes) {
        return clubMemberDAO.addMember(clubId, userId, memberRole, notes);
    }

    public boolean removeMember(int clubId, int userId) {
        return clubMemberDAO.removeMember(clubId, userId);
    }

    public int countTotalClubs() {
        return clubDAO.countTotalClubs();
    }
}
