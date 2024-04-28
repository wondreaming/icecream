package com.example.icecream.notification.service;

import com.example.icecream.notification.document.FcmToken;
import com.example.icecream.notification.document.NotificationList;
import com.example.icecream.notification.dto.LoginRequestDto;
import com.example.icecream.notification.dto.NotificationResponseDto;
import com.example.icecream.notification.repository.FcmTokenRepository;
import com.example.icecream.notification.repository.NotificationListRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.ActiveProfiles;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ActiveProfiles("local")
public class NotificationServiceTest {

    @Mock
    private FcmTokenRepository fcmTokenRepository;

    @Mock
    private NotificationListRepository notificationListRepository;

    @InjectMocks
    private NotificationServiceImpl notificationService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    @DisplayName("새로운 유저일 경우 FcmToken 저장")
    void testSaveOrUpdateFcmToken_saveToken() {
        int userId = 1;
        String token = "testFcmToken";
        LoginRequestDto loginRequestDto = new LoginRequestDto(userId, token);

        when(fcmTokenRepository.findByUserId(userId)).thenReturn(null);
        when(fcmTokenRepository.save(any(FcmToken.class))).thenAnswer(invocation -> invocation.getArgument(0));

        FcmToken result = notificationService.saveOrUpdateFcmToken(loginRequestDto);

        assertNotNull(result);
        assertEquals(userId, result.getUserId());
        assertEquals(token, result.getToken());

        verify(fcmTokenRepository, times(1)).findByUserId(userId);
        verify(fcmTokenRepository, times(1)).save(any(FcmToken.class));
    }

    @Test
    @DisplayName("기존 유저일 경우 FcmToken 업데이트")
    void testSaveOrUpdateFcmToken_updateToken() {
        int userId = 1;
        String token = "testFcmToken";
        LoginRequestDto loginRequestDto = new LoginRequestDto(userId, token);
        FcmToken existingToken = FcmToken.builder()
                .userId(userId)
                .token("oldToken")
                .build();

        when(fcmTokenRepository.findByUserId(userId)).thenReturn(existingToken);
        when(fcmTokenRepository.save(any(FcmToken.class))).thenAnswer(invocation -> invocation.getArgument(0));

        FcmToken result = notificationService.saveOrUpdateFcmToken(loginRequestDto);

        assertNotNull(result);
        assertEquals(userId, result.getUserId());
        assertEquals(token, result.getToken());

        verify(fcmTokenRepository, times(1)).findByUserId(userId);
        verify(fcmTokenRepository, times(1)).save(any(FcmToken.class));
    }

    @Test
    @DisplayName("NotificationList 저장 테스트")
    void testSaveNotificationList() {
        int userId = 1;
        String content = "testContent";
        NotificationList notificationList = NotificationList.builder()
                .userId(userId)
                .content(content)
                .build();

        when(notificationListRepository.save(any(NotificationList.class))).thenReturn(notificationList);

        NotificationList result = notificationService.saveNotificationList(userId, content);

        assertNotNull(result);
        assertEquals(userId, result.getUserId());
        assertEquals(content, result.getContent());

        verify(notificationListRepository, times(1)).save(any(NotificationList.class));
    }

    @Test
    @DisplayName("특정 사용자의 NotificationList(최신 날짜 우선 정렬) 조회")
    void testGetNotificationList() {
        int userId = 1;
        String content1 = "testContent1";
        String content2 = "testContent2";
        NotificationList notificationList1 = NotificationList.builder()
                .userId(userId)
                .content(content1)
                .build();
        NotificationList notificationList2 = NotificationList.builder()
                .userId(userId)
                .content(content2)
                .build();
        List<NotificationList> notificationLists = Arrays.asList(notificationList2, notificationList1);

        when(notificationListRepository.findByUserIdOrderByCreatedAtDesc(userId)).thenReturn(notificationLists);

        List<NotificationResponseDto> result = notificationService.getNotificationList(userId);

        assertNotNull(result);
        assertEquals(2, result.size());
        assertEquals(content2, result.get(0).getContent());
        assertEquals(content1, result.get(1).getContent());

        verify(notificationListRepository, times(1)).findByUserIdOrderByCreatedAtDesc(userId);
    }
}