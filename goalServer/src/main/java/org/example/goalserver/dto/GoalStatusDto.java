package org.example.goalserver.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.util.Map;

@Getter
@Builder
public class GoalStatusDto {

    @NotNull
    private Map<LocalDate, Integer> goalStatusMap;
}
