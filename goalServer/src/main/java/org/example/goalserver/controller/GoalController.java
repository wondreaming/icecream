package org.example.goalserver.controller;

import org.example.goalserver.dto.ApiResponseDto;
import org.example.goalserver.dto.CreateGoalDto;
import org.example.goalserver.dto.GoalStatusDto;
import org.example.goalserver.dto.UpdateGoalDto;
import org.example.goalserver.dto.UpdateGoalStatusDto;
import org.example.goalserver.entity.Goal;
import org.example.goalserver.service.GoalService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
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
    public ApiResponseDto<List<Goal>> getGoal(@RequestParam(name = "user_id") int userId) {
        List<Goal> goals = goalService.getGoals(userId);
        return ApiResponseDto.success("목표를 불러왔습니다.", goals);
    }

    @GetMapping("/goal/status")
    public ApiResponseDto<Map<LocalDate, Integer>> getGoalStatus(
            @RequestParam("user_id") int userId,
            @RequestParam("date") LocalDate date) {
        GoalStatusDto goalStatus = goalService.getGoalStatus(userId, date);
        return ApiResponseDto.success("목표 상태를 불러왔습니다.", goalStatus.getGoalStatusMap());
    }

    @PatchMapping("/goal/status")
    public ApiResponseDto<String> updateGoalStatus(@RequestBody UpdateGoalStatusDto updateGoalStatusDto) {
        goalService.updateGoalStatus(updateGoalStatusDto);
        return ApiResponseDto.success("목표 상태를 수정하였습니다.", null);
    }
}
