package com.example.icecream.domain.user.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserErrorCode {

    USER_NOT_FOUND("등록된 유저 정보를 찾을 수 없습니다"),
    DUPLICATE_LOGIN_ID("이미 사용 중인 로그인 ID 입니다."),
    PASSWORD_MISMATCH("비밀번호와 비밀번호 확인이 일치하지 않습니다."),
    NOT_CHILD("이름을 변경하려는 대상이 부모 유저 입니다."),
    CHILD_NOT_ASSOCIATED("현재 부모에 등록된 자녀가 아닙니다."),
    INVALID_CURRENT_PASSWORD("현재 비밀번호가 일치하지 않습니다."),
    NO_NEW_PASSWORD_PROVIDED("현재와 동일한 비밀번호 입니다.");

    private final String message;
}
