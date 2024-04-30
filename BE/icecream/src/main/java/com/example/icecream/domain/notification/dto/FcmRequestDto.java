package com.example.icecream.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class FcmRequestDto {

    private String token;
    private String title;
    private String body;
    private String key1;
    private String key2;
    private String key3;
}
