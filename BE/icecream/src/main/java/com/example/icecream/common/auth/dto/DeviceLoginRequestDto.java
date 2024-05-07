package com.example.icecream.common.auth.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class DeviceLoginRequestDto {

    @NotBlank
    private String deviceId;

    private String refreshToken;

    @NotBlank
    private String fcmToken;
}
