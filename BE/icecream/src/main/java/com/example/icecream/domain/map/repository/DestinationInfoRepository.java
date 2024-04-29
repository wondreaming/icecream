package com.example.icecream.domain.map.repository;

import com.example.icecream.domain.map.entity.DestinationInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DestinationInfoRepository extends JpaRepository<DestinationInfo, Integer> {
}
