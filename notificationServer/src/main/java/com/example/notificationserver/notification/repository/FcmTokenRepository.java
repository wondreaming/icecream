package com.example.notificationserver.notification.repository;

import com.example.notificationserver.notification.document.FcmToken;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FcmTokenRepository extends MongoRepository<FcmToken, String> {

    FcmToken findByUserId(int userId);
    FcmToken findByToken(String token);
}
