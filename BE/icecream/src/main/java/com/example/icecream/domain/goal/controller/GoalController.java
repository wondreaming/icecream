package com.example.icecream.domain.goal.controller;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.goal.dto.CreateGoalDto;
import com.example.icecream.domain.goal.dto.UpdateGoalDto;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.service.GoalService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class GoalController {

    private final GoalService goalService;

    @PostMapping("/goal")
    public ApiResponseDto<String> createGoal(@RequestBody CreateGoalDto createGoalDto) {
        goalService.createGoal(createGoalDto);
        return ApiResponseDto.success("목표를 설정하였습니다.", null);
    }

    @PatchMapping("/goal")
    public ApiResponseDto<String> updateGoal(@RequestBody UpdateGoalDto updateGoalDto) {
        goalService.updateGoal(updateGoalDto);
        return ApiResponseDto.success("목표를 수정하였습니다.", null);
    }

    @GetMapping("/goal")
    public ApiResponseDto<List<Goal>> getGoal(@RequestParam int userId) {
        List<Goal> goals = goalService.getGoals(userId);
        return ApiResponseDto.success("목표를 불러왔습니다.", goals);
    }

    @GetMapping("/goal/status")
    public ApiResponseDto<Object> getGoalStatus(
            @RequestParam("date") LocalDate date,
            @RequestParam("user_id") int userId) {

        List<Map<LocalDate, Integer>> goalStatus = goalService.getGoalStatus(date, userId);
        return ApiResponseDto.success("목표 상태를 불러왔습니다.", goalStatus);
    }

    @PatchMapping("/goal/status")
    public ApiResponseDto<String> updateGoalStatus(@RequestBody Map<String, Object> body) {
        goalService.updateGoalStatus(body);
        return ApiResponseDto.success("목표 상태를 수정하였습니다.", null);
    }
}
