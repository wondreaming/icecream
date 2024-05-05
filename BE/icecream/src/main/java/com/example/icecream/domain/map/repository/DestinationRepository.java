package com.example.icecream.domain.map.repository;

import com.example.icecream.domain.map.entity.Destination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;
import java.util.List;

@Repository
public interface DestinationRepository extends JpaRepository<Destination, Integer>{

    List<Destination> findAllByUserId(Integer userId);

    @Query("SELECT d FROM Destination d WHERE d.userId = :userId AND " +
            "(:destinationId IS NULL OR d.id != :destinationId) AND " +
            "((d.startTime <= :startTime AND d.endTime > :startTime) OR " +
            "(d.startTime < :endTime AND d.endTime >= :endTime) OR " +
            "(d.startTime >= :startTime AND d.endTime <= :endTime))")
    List<Destination> findOverlappingDestinationsByTime(@Param("userId") Integer userId,
                                                        @Param("destinationId") Integer destinationId,
                                                        @Param("startTime") LocalTime startTime,
                                                        @Param("endTime") LocalTime endTime);
}
