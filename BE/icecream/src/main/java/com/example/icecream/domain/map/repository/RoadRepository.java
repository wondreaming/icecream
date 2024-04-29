package com.example.icecream.domain.map.repository;

import com.example.icecream.domain.map.entity.Road;

import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;

import java.util.List;


@Repository
public interface RoadRepository extends JpaRepository<Road, Integer> {
}
