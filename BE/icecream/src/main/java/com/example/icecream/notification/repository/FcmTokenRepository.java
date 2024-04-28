package com.example.icecream.notification.repository;

import com.example.icecream.notification.entity.FcmToken;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FcmTokenRepository extends MongoRepository<FcmToken, String> {
}
