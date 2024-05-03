package com.example.icecream.domain.goal.document;

import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.MongoId;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Document(collection = "goal_status")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GoalStatus {

    @MongoId
    private String id;

    @Field(name = "user_id")
    private int userId;

    @Field(name = "result")
    private List<Map<LocalDate, Integer>> result;

    @Field(name = "created_at")
    @CreatedDate
    private String createdAt;

    @Field(name = "updated_at")
    @LastModifiedDate
    private String updatedAt;
}
