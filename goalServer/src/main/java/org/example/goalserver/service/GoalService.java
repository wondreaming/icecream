package org.example.goalserver.service;

import org.example.goalserver.dto.CreateGoalDto;
import org.example.goalserver.dto.GoalStatusDto;
import org.example.goalserver.dto.UpdateGoalDto;
import org.example.goalserver.dto.UpdateGoalStatusDto;
import org.example.goalserver.entity.Goal;

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
