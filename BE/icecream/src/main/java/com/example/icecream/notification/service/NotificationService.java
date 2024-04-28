package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.LoginRequestDto;
import com.example.icecream.notification.dto.NotificationResponseDto;

import java.util.List;

public interface NotificationService {

    FcmToken saveOrUpdateFcmToken(LoginRequestDto loginRequestDto);
    NotificationList saveNotificationList(Integer UserId, String content);
    List<NotificationResponseDto> getNotificationList(Integer UserId);
    // TODO: FCM 인증 및 발송 로직 추가 필요
}
