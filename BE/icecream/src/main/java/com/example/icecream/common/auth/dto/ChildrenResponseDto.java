package com.example.icecream.common.auth.dto;


import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class ChildrenResponseDto {
    private final int user_id;
    private final String profile_image;
    private final String username;
    private final String phone_number;
}
