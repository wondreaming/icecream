package com.example.notificationserver.notification.service;

import com.example.notificationserver.notification.document.FcmToken;
import com.example.notificationserver.notification.document.NotificationList;
import com.example.notificationserver.notification.dto.FcmRequestDto;
import com.example.notificationserver.notification.dto.FcmRequestDto2;
import com.example.notificationserver.notification.dto.LoginRequestDto;
import com.example.notificationserver.notification.dto.NotificationResponseDto;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.io.IOException;
import java.util.List;

public interface NotificationService {

    FcmToken saveOrUpdateFcmToken(LoginRequestDto loginRequestDto);
    NotificationList saveNotificationList(Integer UserId, String content);
    List<NotificationResponseDto> getNotificationList(Integer UserId);
    void sendMessageTo(FcmRequestDto fcmRequestDto) throws IOException;
    String getAccessToken() throws IOException;
    String createMessage(FcmRequestDto fcmRequestDto) throws JsonProcessingException;
    void sendMessageToUsers(FcmRequestDto2 fcmRequestDto2);
}
