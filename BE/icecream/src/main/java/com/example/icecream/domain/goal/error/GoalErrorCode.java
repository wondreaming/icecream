package com.example.icecream.domain.goal.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum GoalErrorCode {

    REGISTER_GOAL_ACCESS_DENIED("목표 등록 권한이 없습니다.");

    private final String message;
}
