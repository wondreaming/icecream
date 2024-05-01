package com.example.icecream.domain.goal.controller;

import com.example.icecream.domain.goal.dto.ApiResponseDto;
import com.example.icecream.domain.goal.dto.GoalDto;
import com.example.icecream.domain.goal.service.GoalService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api")
public class GoalController {

    private final GoalService goalService;

    @PostMapping("/goal")
    public ApiResponseDto<String> createGoal(
            @RequestBody GoalDto goalDto,
            @AuthenticationPrincipal UserDetails loginUser
    ) {


        if (goalDto.getUserId() == 0) {
            return ApiResponseDto.notFound("자녀가 선택되어있지 않습니다.");
        } else if (false) {
            // 추가하기
            // loginUser.getUsername()을 통해 로그인한 사용자의 아이디를 가져올 수 있습니다.
        } else if (goalDto.getPeriod() == 0) {
            return ApiResponseDto.notFound("기간이 선택되어있지 않습니다.");
        } else if (goalDto.getContent() == null) {
            return ApiResponseDto.notFound("보상이 없습니다.");
        }

        GoalDto createdGoal = goalService.createGoal(goalDto);
        return ApiResponseDto.success("목표를 설정하였습니다.", null);
    }

    @GetMapping("/goal")
    public ApiResponseDto<GoalDto> getGoal(@RequestBody int userId) {
        GoalDto goal = goalService.getGoal(userId);
        if (goal == null) {
            return ApiResponseDto.notFound("목표가 없습니다.");
        }
        return ApiResponseDto.success("목표를 불러왔습니다.", goal);
    }
}
