package com.example.icecream.domain.goal.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class GoalDto {

    private int userId;
    private int period;
    private String content;
}
