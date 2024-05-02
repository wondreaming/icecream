package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.repository.postgres.GoalRepository;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;
    private final UsersRepository usersRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;

    @Override
    public CreateGoalDto createGoal(CreateGoalDto createGoalDto) {
        Goal goal = Goal.builder()
                .userId(createGoalDto.getUserId())
                .period(createGoalDto.getPeriod())
                .content(createGoalDto.getContent())
                .build();

        Goal savedGoal = goalRepository.save(goal);

        return CreateGoalDto.builder()
                .userId(savedGoal.getUserId())
                .period(savedGoal.getPeriod())
                .content(savedGoal.getContent())
                .build();
    }

    @Override
    public UpdateGoalDto updateGoal(UpdateGoalDto updateGoalDto) {
        Goal goal = goalRepository.findById(updateGoalDto.getGoalId()).orElse(null);
        if (goal == null) {
            // 수정하기
            throw new IllegalArgumentException("해당 목표가 존재하지 않습니다.");
        }
        goal.updateGoal(updateGoalDto.getPeriod(), updateGoalDto.getContent());

        Goal updatedGoal = goalRepository.save(goal);
        return UpdateGoalDto.builder()
                .goalId(updatedGoal.getUserId())
                .period(updatedGoal.getPeriod())
                .content(updatedGoal.getContent())
                .build();
    }

    @Override
    public List<Goal> getGoals(int userId) {
        return goalRepository.findAllByUserId(userId);
    }
}
