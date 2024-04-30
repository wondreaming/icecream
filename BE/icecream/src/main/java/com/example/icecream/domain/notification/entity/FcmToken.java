package com.example.icecream.domain.notification.entity;

import jakarta.persistence.Entity;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Document(collection = "fcm_token")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class FcmToken {

    @MongoId
    private String id;

    @Field(name = "user_id")
    private int userId;

    @Field(name = "token")
    private String token;

    @Field(name = "created_at")
    private String createdAt;

    @Field(name = "updated_at")
    private String updatedAt;
}
