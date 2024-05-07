package com.example.icecream.domain.goal.controller;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.GoalStatusDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalStatusDto;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.service.GoalService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class GoalController {

    private final GoalService goalService;

    @PostMapping("/goal")
    public ResponseEntity<ApiResponseDto<String>> createGoal(@RequestBody CreateGoalDto createGoalDto) {
        goalService.createGoal(createGoalDto);
        return ApiResponseDto.success("목표를 설정하였습니다.", null);
    }

    @PatchMapping("/goal")
    public ResponseEntity<ApiResponseDto<String>> updateGoal(@RequestBody UpdateGoalDto updateGoalDto) {
        goalService.updateGoal(updateGoalDto);
        return ApiResponseDto.success("목표를 수정하였습니다.", null);
    }

    @GetMapping("/goal")
    public ResponseEntity<ApiResponseDto<List<Goal>>> getGoal(@RequestParam(name = "user_id") int userId) {
        List<Goal> goals = goalService.getGoals(userId);
        return ApiResponseDto.success("목표를 불러왔습니다.", goals);
    }

    @GetMapping("/goal/status")
    public ResponseEntity<ApiResponseDto<Map<LocalDate, Integer>>> getGoalStatus(
            @RequestParam("user_id") int userId,
            @RequestParam("date") LocalDate date) {
        GoalStatusDto goalStatus = goalService.getGoalStatus(userId, date);
        return ApiResponseDto.success("목표 상태를 불러왔습니다.", goalStatus.getGoalStatusMap());
    }

    @PatchMapping("/goal/status")
    public ResponseEntity<ApiResponseDto<String>> updateGoalStatus(@RequestBody UpdateGoalStatusDto updateGoalStatusDto) {
        goalService.updateGoalStatus(updateGoalStatusDto);
        return ApiResponseDto.success("목표 상태를 수정하였습니다.", null);
    }
}
