package com.example.icecream.domain.map.repository;

import com.example.icecream.domain.map.entity.Destination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DestinationRepository extends JpaRepository<Destination, Integer>{
}
