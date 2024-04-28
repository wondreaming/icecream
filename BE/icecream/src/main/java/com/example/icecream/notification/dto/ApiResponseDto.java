package com.example.icecream.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ApiResponseDto<T> {

    private int status;
    private String message;
    private T data;

    public static <T> ApiResponseDto<T> success(T data) {
        return new ApiResponseDto<>(200, "알림 목록 조회에 성공하였습니다.", data);
    }

    public static <T> ApiResponseDto<T> notFound() {
        return new ApiResponseDto<>(404, "알림 목록이 존재하지 않습니다.", null);
    }
}
