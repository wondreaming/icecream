package com.example.icecream.common.handler;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.common.exception.InternalServerException;
import com.example.icecream.common.exception.NotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ApiResponseDto<String>> handleNotFoundException(NotFoundException e) {
        return ApiResponseDto.notFound(e.getMessage());
    }

    @ExceptionHandler(InternalServerException.class)
    public ResponseEntity<ApiResponseDto<String>> handleInternalServerException(InternalServerException e) {
        return ApiResponseDto.error(e.getMessage());
    }
}
