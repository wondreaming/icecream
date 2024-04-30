package com.example.icecream.domain.notification.entity;

import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Document(collection = "notification")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Notification {

    @MongoId
    private String id;

    @Field(name = "user_id")
    private int userId;

    @Field(name = "content")
    private String content;

    @Field(name = "created_at")
    private String createdAt;

    @Field(name = "updated_at")
    private String updatedAt;
}
