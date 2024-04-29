package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.*;
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
