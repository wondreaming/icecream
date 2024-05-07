package com.example.icecream.common.auth.dto;

import lombok.Getter;

@Getter
public class LoginRequestDto {
    private String loginId;
    private String password;
    private String fcmToken;
}
