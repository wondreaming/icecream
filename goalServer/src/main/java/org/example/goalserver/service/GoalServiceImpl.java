package org.example.goalserver.service;

import org.example.goalserver.document.GoalStatus;
import org.example.goalserver.dto.CreateGoalDto;
import org.example.goalserver.dto.GoalStatusDto;
import org.example.goalserver.dto.UpdateGoalDto;
import org.example.goalserver.dto.UpdateGoalStatusDto;
import org.example.goalserver.entity.Goal;
import org.example.goalserver.repository.mongodb.GoalStatusRepository;
import org.example.goalserver.repository.postgres.GoalRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;
    private final GoalStatusRepository goalStatusRepository;

    @Override
    @Transactional
    public void createGoal(CreateGoalDto createGoalDto) {
        Goal goal = Goal.builder()
                .userId(createGoalDto.getUserId())
                .period(createGoalDto.getPeriod())
                .content(createGoalDto.getContent())
                .isActive(true)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        goalRepository.save(goal);
    }

    @Override
    @Transactional
    public void updateGoal(UpdateGoalDto updateGoalDto) {
        Goal goal = goalRepository.findById(updateGoalDto.getGoalId()).orElse(null);
        if (goal == null) {
            // 수정하기
            throw new IllegalArgumentException("해당 목표가 존재하지 않습니다.");
        }
        goal.updateGoal(updateGoalDto.getPeriod(), updateGoalDto.getContent());
        goalRepository.save(goal);
    }

    @Override
    public List<Goal> getGoals(int userId) {
        return goalRepository.findAllByUserId(userId);
    }

    @Override
    @Transactional
    public void createGoalStatus(int userId) {
        GoalStatus goalStatus = GoalStatus.builder()
                .userId(userId)
                .result(new HashMap<>())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        goalStatusRepository.save(goalStatus);
    }

    @Override
    public GoalStatusDto getGoalStatus(int userId, LocalDate date) {
        GoalStatus goalStatus = goalStatusRepository.findByUserId(userId);
        Map<LocalDate, Integer> allResult = goalStatus.getResult();
        int allResultSize = allResult.size();

        LocalDate todayDate = LocalDate.now();
        int period = Period.between(date, todayDate).getDays();

        Map<LocalDate, Integer> result = new HashMap<>();
        for (int i = period; i < period + 3; i++) {
            if (i >= allResultSize) {
                break;
            }
            result.put(date.minusDays(i), allResult.get(date.minusDays(i)));
        }
        return GoalStatusDto.builder()
                .goalStatusMap(result)
                .build();
    }

    @Override
    @Transactional
    public void updateGoalStatus(UpdateGoalStatusDto updateGoalStatusDto) {
        GoalStatus goalStatus = goalStatusRepository.findByUserId(updateGoalStatusDto.getUserId());
        if (!goalStatus.getResult().containsKey(updateGoalStatusDto.getDate())) {
            throw new IllegalArgumentException("해당 사용자의 목표 상태가 존재하지 않습니다.");
        }
        goalStatus.updateGoalStatus(updateGoalStatusDto.getDate(), updateGoalStatusDto.getStatus());
        goalStatusRepository.save(goalStatus);
    }

}
