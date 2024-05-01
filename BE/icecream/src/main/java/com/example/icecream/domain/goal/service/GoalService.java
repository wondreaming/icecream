package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.GoalDto;

public interface GoalService {

    GoalDto createGoal(GoalDto goalDto);
    GoalDto getGoal(int userId);
}
