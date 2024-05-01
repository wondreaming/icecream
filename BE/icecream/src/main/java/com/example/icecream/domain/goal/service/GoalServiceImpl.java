package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.dto.GoalDto;
import com.example.icecream.domain.goal.entity.postgres.Goal;
import com.example.icecream.domain.goal.repository.postgres.GoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;

    @Override
    public GoalDto createGoal(GoalDto goalDto) {
            Goal goal = Goal.builder()
                    .userId(goalDto.getUserId())
                    .period(goalDto.getPeriod())
                    .content(goalDto.getContent())
                    .build();

            Goal savedGoal = goalRepository.save(goal);

            return GoalDto.builder()
                    .userId(savedGoal.getUserId())
                    .period(savedGoal.getPeriod())
                    .content(savedGoal.getContent())
                    .build();
        }

    @Override
    public GoalDto getGoal(int userId) {
        return null;
    }

}
