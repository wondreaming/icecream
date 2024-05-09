package com.example.icecream.domain.goal.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateGoalStatusDto {

    @NotNull
    private Integer userId;
    @NotNull
    private LocalDate date;
    @NotNull
    private Integer status;
}
