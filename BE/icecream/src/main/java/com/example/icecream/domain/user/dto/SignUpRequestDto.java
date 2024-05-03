package com.example.icecream.domain.user.dto;


import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SignUpRequestDto {

    @NotNull
    private String username;
    @NotNull
    private String phoneNumber;
    @NotNull
    private String loginId;
    @NotNull
    private String password;
    @NotNull
    private String passwordCheck;
    @NotNull
    private String deviceId;
}

