package com.example.icecream.domain.goal.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateGoalDto {

    @NotNull
    private Integer userId;
    @NotNull
    private Integer period;
    @NotNull
    private String content;
}
