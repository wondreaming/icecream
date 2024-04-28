package com.example.icecream.map.repository;

import com.example.icecream.map.entity.CrosswalkCCTVMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CrosswalkCCTVMappingRepository extends JpaRepository<CrosswalkCCTVMapping, Integer> {
}
