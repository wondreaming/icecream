package com.example.goalserver.goal.service;

import com.example.goalserver.goal.dto.CreateGoalDto;
import com.example.goalserver.goal.dto.GoalStatusDto;
import com.example.goalserver.goal.dto.UpdateGoalDto;
import com.example.goalserver.goal.dto.UpdateGoalStatusDto;
import com.example.goalserver.goal.entity.Goal;

import java.time.LocalDate;
import java.util.List;

public interface GoalService {

    void createGoal(CreateGoalDto createGoalDto, Integer parentId);
    void updateGoal(UpdateGoalDto updateGoalDto, Integer parentId);
    List<Goal> getGoals(int userId, Integer selfId);
    void createGoalStatus(int userId);
    GoalStatusDto getGoalStatus(int userId, LocalDate date);
    void updateGoalStatus(UpdateGoalStatusDto updateGoalStatusDto, Integer parentId);
}
