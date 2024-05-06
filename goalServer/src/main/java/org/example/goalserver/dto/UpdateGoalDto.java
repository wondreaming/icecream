package org.example.goalserver.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UpdateGoalDto {

    @NotNull
    @JsonProperty("goal_id")
    private Integer goalId;
    @NotNull
    private Integer period;
    @NotNull
    private String content;
}
