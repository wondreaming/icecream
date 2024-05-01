package com.example.icecream.domain.goal.controller;

import com.example.icecream.domain.goal.dto.ApiResponseDto;
import com.example.icecream.domain.goal.dto.GoalDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api")
public class GoalController {

    @PostMapping("/goal")
    public ApiResponseDto<String> createGoal(@RequestBody GoalDto goalDto) {
        return ApiResponseDto.success("목표를 설정하였습니다.", null);
    }
}
