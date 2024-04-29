package com.example.icecream.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class FcmMessageDto {

    private boolean validateOnly;
    private Message message;

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Message {
        private String token;
        private Notification notification;
        private Data data;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Notification {
        private String title;
        private String body;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Data {
        private String key1;
        private String key2;
        private String key3;
    }
}
