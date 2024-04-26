package com.example.icecream.user.repository;

import com.example.icecream.user.entity.ParentChildMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParentChildMappingRepository extends JpaRepository<ParentChildMapping, Integer> {
}
