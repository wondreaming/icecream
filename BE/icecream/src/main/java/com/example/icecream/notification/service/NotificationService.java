package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.FcmMessageDto;
import com.example.icecream.notification.dto.FcmRequestDto;
import com.example.icecream.notification.dto.LoginRequestDto;
import com.example.icecream.notification.dto.NotificationResponseDto;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.io.IOException;
import java.util.List;

public interface NotificationService {

    FcmToken saveOrUpdateFcmToken(LoginRequestDto loginRequestDto);
    NotificationList saveNotificationList(Integer UserId, String content);
    List<NotificationResponseDto> getNotificationList(Integer UserId);
    // TODO: FCM 인증 및 발송 로직 추가 필요
    void sendMessageTo(FcmRequestDto fcmRequestDto) throws IOException;
    String getAccessToken() throws IOException;
    String createMessage(FcmRequestDto fcmRequestDto) throws JsonProcessingException;
}
