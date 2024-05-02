package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.entity.Goal;

import java.util.List;

public interface GoalService {

    CreateGoalDto createGoal(CreateGoalDto createGoalDto);
    UpdateGoalDto updateGoal(UpdateGoalDto updateGoalDto);
    List<Goal> getGoals(int userId);
}
