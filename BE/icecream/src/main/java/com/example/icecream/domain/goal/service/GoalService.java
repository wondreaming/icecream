package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.GoalStatusDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalStatusDto;
import com.example.icecream.domain.goal.entity.Goal;

import java.time.LocalDate;
import java.util.List;

public interface GoalService {

    void createGoal(CreateGoalDto createGoalDto);
    void updateGoal(UpdateGoalDto updateGoalDto);
    List<Goal> getGoals(int userId);
    void createGoalStatus(int userId);
    GoalStatusDto getGoalStatus(int userId, LocalDate date);
    void updateGoalStatus(UpdateGoalStatusDto updateGoalStatusDto);
}
