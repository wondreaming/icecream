package com.example.icecream.notification.document;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class NotificationListTest {

    @Test
    void notificationListBuilderTest() {
        NotificationList notificationList = NotificationList.builder()
                .userId(1)
                .content("testNotification")
                .build();

        assertEquals(1, notificationList.getUserId());
        assertEquals("testNotification", notificationList.getContent());
    }
}
