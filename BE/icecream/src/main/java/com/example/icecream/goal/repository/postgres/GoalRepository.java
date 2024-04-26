package com.example.icecream.goal.repository.postgres;

import com.example.icecream.goal.entity.postgres.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalRepository extends JpaRepository<Goal, Integer> {
}
