package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.FcmMessageDto;
import com.example.icecream.notification.dto.FcmRequestDto;
import com.example.icecream.notification.dto.LoginRequestDto;
import com.example.icecream.notification.dto.NotificationResponseDto;
import com.example.icecream.notification.repository.FcmTokenRepository;
import com.example.icecream.notification.repository.NotificationListRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final FcmTokenRepository fcmTokenRepository;
    private final NotificationListRepository notificationListRepository;
    private final String FCM_API_URL;
    private final ObjectMapper objectMapper;

    public NotificationServiceImpl(FcmTokenRepository fcmTokenRepository,
                                   NotificationListRepository notificationListRepository,
                                   @Value("${FCM_API_URL}") String FCM_API_URL,
                                   ObjectMapper objectMapper) {
        this.fcmTokenRepository = fcmTokenRepository;
        this.notificationListRepository = notificationListRepository;
        this.FCM_API_URL = FCM_API_URL;
        this.objectMapper = objectMapper;
    }

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

    @Override
    @Transactional
    public void sendMessageTo(FcmRequestDto fcmRequestDto) throws IOException {
        String message = createMessage(fcmRequestDto);

        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody = RequestBody.create(message,
                MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(FCM_API_URL)
                .post(requestBody)
                .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.body() != null) {
                saveNotificationList(fcmTokenRepository.findByToken(fcmRequestDto.getToken()).getUserId(), fcmRequestDto.getBody());
                System.out.println("메시지 내용: " + message);
                System.out.println("Successfully sent message to FCM: " + response.body().string());
            } else {
                throw new IOException("Failed to send message to FCM");
            }
        } catch (IOException e) {
            throw new IOException("Failed to send message to FCM", e);
        }
    }

    @Override
    public String getAccessToken() throws IOException {
        String firebaseConfigPath = "fcm-admin-sdk.json";

        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }

    @Override
    @Transactional
    public String createMessage(FcmRequestDto fcmRequestDto) throws JsonProcessingException {
        FcmMessageDto fcmMessageDto = FcmMessageDto.builder()
                .validateOnly(false)
                .message(FcmMessageDto.Message.builder()
                        .token(fcmRequestDto.getToken())
                        .notification(FcmMessageDto.Notification.builder()
                                .title(fcmRequestDto.getTitle())
                                .body(fcmRequestDto.getBody())
                                .build())
                        .data(FcmMessageDto.Data.builder()
                                .key1(fcmRequestDto.getKey1())
                                .key2(fcmRequestDto.getKey2())
                                .key3(fcmRequestDto.getKey3())
                                .build())
                        .build())
                .build();

        return objectMapper.writeValueAsString(fcmMessageDto);
    }
}
