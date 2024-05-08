package com.example.icecream.common.auth.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AuthErrorCode {

    INVALID_TOKEN("권한 정보가 없는 토큰입니다."),
    INVALID_HTTP_METHOD("로그인은 POST 요청만 가능합니다");

    private final String message;
}
