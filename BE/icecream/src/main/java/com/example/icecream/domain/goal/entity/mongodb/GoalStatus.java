package com.example.icecream.domain.goal.entity.mongodb;

import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.MongoId;

import java.util.ArrayList;
import java.util.Arrays;
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
    private ArrayList<Map<String, Integer>> result;
}
