package com.example.icecream.common.auth.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AuthErrorCode {

    INVALID_TOKEN("권한 정보가 없는 토큰입니다."),
    INVALID_HTTP_METHOD("로그인은 POST 요청만 가능합니다"),
    INPUT_SERIALIZE_FAIL("입력 정보를 역직렬화 하는데 실패했습니다."),
    NO_TOKEN_IN_REDIS("Redis에 해당 Refresh Token이 존재하지 않습니다");


    private final String message;
}
