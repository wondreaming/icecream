package com.example.icecream.goal.repository.mongodb;

import com.example.icecream.goal.entity.mongodb.GoalStatus;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalStatusRepository extends MongoRepository<GoalStatus, String>{
}
