package com.example.icecream.domain.goal.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ApiResponseDto<T> {

    private int status;
    private String message;
    private T data;

    public static <T> ApiResponseDto<T> success(String message, T data) {
        return new ApiResponseDto<>(200, message, data);
    }

    public static <T> ApiResponseDto<T> notFound(String message) {
        return new ApiResponseDto<>(404, message, null);
    }

    public static <T> ApiResponseDto<T> error(String errorMessage) {
        return new ApiResponseDto<>(500, "서버 에러 발생: " + errorMessage, null);
    }
}
