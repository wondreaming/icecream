package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.LoginRequestDto;
import com.example.icecream.notification.dto.NotificationResponseDto;
import com.example.icecream.notification.repository.FcmTokenRepository;
import com.example.icecream.notification.repository.NotificationListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final FcmTokenRepository fcmTokenRepository;
    private final NotificationListRepository notificationListRepository;

    @Override
    @Transactional
    public FcmToken saveOrUpdateFcmToken(LoginRequestDto loginRequestDto) {
        FcmToken fcmTokenEntity = fcmTokenRepository.findByUserId(loginRequestDto.getUserId());
        if (fcmTokenEntity == null) {
            fcmTokenEntity = FcmToken.builder()
                    .userId(loginRequestDto.getUserId())
                    .token(loginRequestDto.getToken())
                    .build();
        } else {
            fcmTokenEntity.updateToken(loginRequestDto.getToken());
        }
        return fcmTokenRepository.save(fcmTokenEntity);
    }

    @Override
    @Transactional
    public NotificationList saveNotificationList(Integer UserId, String content) {
        NotificationList notificationList = NotificationList.builder()
                .userId(UserId)
                .content(content)
                .build();
        return notificationListRepository.save(notificationList);
    }

    @Override
    public List<NotificationResponseDto> getNotificationList(Integer UserId) {
        List<NotificationList> notificationLists = notificationListRepository.findByUserIdOrderByCreatedAtDesc(UserId);
        return notificationLists.stream()
                .map(notification -> new NotificationResponseDto(notification.getContent(), notification.getCreatedAt()))
                .collect(Collectors.toList());
    }

}
