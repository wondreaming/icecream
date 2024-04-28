package com.example.icecream.notification.dto;

import lombok.Getter;
import lombok.AllArgsConstructor;

@Getter
@AllArgsConstructor
public class LoginRequestDto {

    private int userId;
    private String token;
}
