package com.example.icecream.domain.goal.repository.postgres;

import com.example.icecream.domain.goal.entity.postgres.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalRepository extends JpaRepository<Goal, Integer> {
}
