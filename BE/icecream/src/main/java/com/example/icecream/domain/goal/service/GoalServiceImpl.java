package com.example.icecream.domain.goal.service;

import com.example.icecream.common.exception.DataAccessException;
import com.example.icecream.common.service.CommonService;
import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.GoalStatusDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalStatusDto;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.error.GoalErrorCode;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.goal.repository.postgres.GoalRepository;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
import java.util.*;

@Service
public class GoalServiceImpl extends CommonService implements GoalService {

    private final GoalRepository goalRepository;
    private final GoalStatusRepository goalStatusRepository;

    public GoalServiceImpl(UserRepository userRepository,
                           ParentChildMappingRepository ParentChildMappingRepository,
                           GoalRepository goalRepository,
                           GoalStatusRepository goalStatusRepository) {
        super(userRepository, ParentChildMappingRepository);
        this.goalRepository = goalRepository;
        this.goalStatusRepository = goalStatusRepository;
    }

    @Override
    @Transactional
    public void createGoal(CreateGoalDto createGoalDto, Integer parentId) {
        if (!isParentUserWithPermission(parentId, createGoalDto.getUserId())) {
            throw new DataAccessException(GoalErrorCode.REGISTER_GOAL_ACCESS_DENIED.getMessage());
        } else if (true) {
            // 활성화된 목표 있는 상태에서 목표를 등록
        }
        Goal goal = Goal.builder()
                .userId(createGoalDto.getUserId())
                .period(createGoalDto.getPeriod())
                .content(createGoalDto.getContent())
                .isActive(true)
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
        Map<LocalDate, Integer> firstResult = new HashMap<>();
        firstResult.put(LocalDate.now(), 0);

        GoalStatus goalStatus = GoalStatus.builder()
                .userId(userId)
                .result(firstResult)
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
