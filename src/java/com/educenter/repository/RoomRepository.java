package com.educenter.repository;

import com.educenter.entity.Room;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class RoomRepository {

    public Optional<Room> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        return Optional.ofNullable(em.find(Room.class, id));
    }

    public Optional<Room> findByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) return Optional.empty();
        try {
            TypedQuery<Room> query = em.createQuery(
                "SELECT r FROM Room r WHERE LOWER(r.code) = LOWER(:code)", Room.class);
            query.setParameter("code", code.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<Room> findAll(EntityManager em) {
        return em.createQuery("SELECT r FROM Room r ORDER BY r.code ASC", Room.class).getResultList();
    }

    public List<Room> findAvailableRooms(EntityManager em) {
        return em.createQuery(
            "SELECT r FROM Room r WHERE r.status = 'AVAILABLE' ORDER BY r.code ASC", Room.class)
            .getResultList();
    }

    public long countTotalRooms(EntityManager em) {
        return em.createQuery("SELECT COUNT(r) FROM Room r", Long.class).getSingleResult();
    }

    public long countAvailableRooms(EntityManager em) {
        return em.createQuery(
            "SELECT COUNT(r) FROM Room r WHERE r.status = 'AVAILABLE'", Long.class).getSingleResult();
    }

    public long countClassesByRoom(EntityManager em, Long roomId) {
        if (roomId == null) return 0;
        return em.createQuery(
            "SELECT COUNT(c) FROM EduClass c WHERE c.room.id = :roomId", Long.class)
            .setParameter("roomId", roomId)
            .getSingleResult();
    }

    public long countSessionsByRoom(EntityManager em, Long roomId) {
        if (roomId == null) return 0;
        return em.createQuery(
            "SELECT COUNT(s) FROM ClassSession s WHERE s.room.id = :roomId", Long.class)
            .setParameter("roomId", roomId)
            .getSingleResult();
    }

    public void save(EntityManager em, Room room) {
        em.persist(room);
    }

    public Room update(EntityManager em, Room room) {
        return em.merge(room);
    }
}
