package org.example.goalserver.repository.mongodb;

import org.example.goalserver.document.GoalStatus;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalStatusRepository extends MongoRepository<GoalStatus, String>{
    GoalStatus findByUserId(int userId);
}
