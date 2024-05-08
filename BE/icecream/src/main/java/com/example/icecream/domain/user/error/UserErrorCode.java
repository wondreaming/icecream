package com.example.icecream.domain.user.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserErrorCode {

    USER_NOT_FOUND("등록된 회원이 아닙니다."),
    DUPLICATE_LOGIN_ID("이미 사용 중인 로그인 ID 입니다."),
    PASSWORD_MISMATCH("비밀번호와 비밀번호 확인이 일치하지 않습니다.");

    private final String message;
}
