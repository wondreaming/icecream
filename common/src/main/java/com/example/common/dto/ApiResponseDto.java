package com.example.common.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.ResponseEntity;

@Getter
public class ApiResponseDto<T> {

    private int status;
    private String message;
    private T data;

    public ApiResponseDto(int status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }
    public static <T> ResponseEntity<ApiResponseDto<T>> success(String message, T data) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(200, message, data);
        return ResponseEntity.status(200).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> success(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(200, message, null);
        return ResponseEntity.status(200).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> created(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(201, message, null);
        return ResponseEntity.status(201).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> badRequest(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(400, message, null);
        return ResponseEntity.status(400).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> unauthorized(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(401, message, null);
        return ResponseEntity.status(401).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> forbidden(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(403, message, null);
        return ResponseEntity.status(403).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> notFound(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(404, message, null);
        return ResponseEntity.status(404).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> conflict(String message) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(409, message, null);
        return ResponseEntity.status(409).body(response);
    }

    public static <T> ResponseEntity<ApiResponseDto<T>> error(String errorMessage) {
        ApiResponseDto<T> response = new ApiResponseDto<T>(500, "서버 에러 발생: " + errorMessage, null);
        return ResponseEntity.status(500).body(response);
    }
}