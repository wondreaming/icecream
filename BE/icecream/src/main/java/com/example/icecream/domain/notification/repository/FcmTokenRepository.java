package com.example.icecream.domain.notification.repository;

import com.example.icecream.domain.notification.entity.FcmToken;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FcmTokenRepository extends MongoRepository<FcmToken, String> {
}
