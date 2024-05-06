package org.example.goalserver.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CreateGoalDto {

    @NotNull
    @JsonProperty("user_id")
    private Integer userId;
    @NotNull
    private Integer period;
    @NotNull
    private String content;
}
