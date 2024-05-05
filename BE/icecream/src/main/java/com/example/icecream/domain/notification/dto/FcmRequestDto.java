package com.example.icecream.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FcmRequestDto {

    private String token;
    private String title;
    private String body;
    private String isOverSpeed;
    private String isCreated;
    private String key3;
}
