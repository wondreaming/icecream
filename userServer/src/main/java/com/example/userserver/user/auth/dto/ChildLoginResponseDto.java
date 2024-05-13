package com.example.userserver.user.auth.dto;


import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChildLoginResponseDto implements LoginResponseDto {

    private int userId;
    private String username;
    private String phoneNumber;
    private String profileImage;
    private String accessToken;
    private String refreshToken;
}
