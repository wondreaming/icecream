package com.example.icecream.domain.goal.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Getter;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDate;

@Getter
@Builder
public class UpdateGoalStatusDto {

    @NotNull
    @JsonProperty(namespace = "user_id")
    private Integer userId;
    @NotNull
    private LocalDate date;
    @NotNull
    private Integer status;
}
