package com.example.icecream.domain.user.repository;

import com.example.icecream.domain.user.entity.ParentChildMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParentChildMappingRepository extends JpaRepository<ParentChildMapping, Integer> {

    boolean existsByParentIdAndChildId(Integer parentId, Integer childId);

    ParentChildMapping findByChildId(Integer childId);
}
