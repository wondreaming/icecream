package com.example.icecream.domain.map.repository;

import com.example.icecream.domain.map.entity.Destination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DestinationRepository extends JpaRepository<Destination, Integer>{

    List<Destination> findAllByUserId(Integer userId);
//    Destination findById(Integer id);
}
