package com.example.icecream.domain.notification.dto;

import lombok.Getter;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class NotificationResponseDto {

    private String content;
    private LocalDateTime datetime;
}
