package com.example.icecream.domain.user.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
@NoArgsConstructor
@AllArgsConstructor
public class SignUpParentRequestDto {

    @NotBlank
    @Pattern(regexp = "^[가-힣a-zA-Z]+$", message = "사용자 이름은 한글 또는 영어로만 구성되어야 합니다.")
    private String username;

    @NotBlank
    @Pattern(regexp = "^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$", message = "올바른 휴대폰 번호 형식이 아닙니다.")
    private String phoneNumber;

    @NotBlank
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9]{6,20}$", message = "로그인 ID는 영문과 숫자를 포함한 6~20자리 이어야 합니다.")
    private String loginId;

    @NotBlank
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9!@#$%^&*]{8,20}$", message = "비밀번호는 영문과 숫자를 포함한 8~20자리 이어야 합니다.")
    private String password;

    @NotBlank
    private String passwordCheck;

    @NotBlank
    private String deviceId;
}

