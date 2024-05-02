package com.example.icecream.domain.goal.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CreateGoalDto {
    @NotNull
    private Integer userId;
    @NotNull
    private Integer period;
    @NotNull
    private String content;
}
