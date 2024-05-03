package com.example.icecream.domain.goal.service;

import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.goal.repository.postgres.GoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;
    private final GoalStatusRepository goalStatusRepository;

    @Override
    public void createGoal(CreateGoalDto createGoalDto) {
        Goal goal = Goal.builder()
                .userId(createGoalDto.getUserId())
                .period(createGoalDto.getPeriod())
                .content(createGoalDto.getContent())
                .build();

        goalRepository.save(goal);
    }

    @Override
    public void updateGoal(UpdateGoalDto updateGoalDto) {
        Goal goal = goalRepository.findById(updateGoalDto.getGoalId()).orElse(null);
        if (goal == null) {
            // 수정하기
            throw new IllegalArgumentException("해당 목표가 존재하지 않습니다.");
        }
        goal.updateGoal(updateGoalDto.getPeriod(), updateGoalDto.getContent());
    }

    @Override
    public List<Goal> getGoals(int userId) {
        return goalRepository.findAllByUserId(userId);
    }

    @Override
    public void createGoalStatus(int userId) {
        GoalStatus goalStatus = GoalStatus.builder()
                .userId(userId)
                .result(new ArrayList<>())
                .build();
        goalStatusRepository.save(goalStatus);
    }

    @Override
    public List<Map<LocalDate, Integer>> getGoalStatus(LocalDate date, int userId) {
        LocalDate todayDate = LocalDate.now();
        List<Map<LocalDate, Integer>> allResult = goalStatusRepository.findByUserId(userId).getResult();
        allResult.sort((map1, map2) -> {
            LocalDate date1 = map1.keySet().iterator().next(); // 첫 번째 맵의 키 추출
            LocalDate date2 = map2.keySet().iterator().next(); // 두 번째 맵의 키 추출
            return date2.compareTo(date1);
        });
        int allResultSize = allResult.size();
        LocalDate startDate = date.minusDays(9);
        return allResult;
    }
}
