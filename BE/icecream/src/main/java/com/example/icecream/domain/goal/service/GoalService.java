package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.entity.Goal;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public interface GoalService {

    void createGoal(CreateGoalDto createGoalDto);
    void updateGoal(UpdateGoalDto updateGoalDto);
    List<Goal> getGoals(int userId);
    void createGoalStatus(int userId);
    List<Map<LocalDate, Integer>> getGoalStatus(LocalDate date, int userId);
}
