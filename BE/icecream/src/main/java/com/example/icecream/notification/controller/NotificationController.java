package com.example.icecream.notification.controller;

import com.example.icecream.notification.dto.ApiResponseDto;
import com.example.icecream.notification.dto.NotificationResponseDto;
import com.example.icecream.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/notification/{userId}")
    public ApiResponseDto<List<NotificationResponseDto>> getNotificationList(@PathVariable int userId) {
        List<NotificationResponseDto> notificationList = notificationService.getNotificationList(userId);
        if (notificationList.isEmpty()) {
            return ApiResponseDto.notFound();
        }
        return ApiResponseDto.success(notificationList);
    }
}
