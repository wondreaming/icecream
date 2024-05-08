package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.service.CctvMessageListenService;
import com.example.icecream.domain.map.dto.CctvMessageDto;
import com.example.icecream.domain.map.service.RedisListenService;
import com.example.icecream.domain.notification.dto.FcmRequestDto2;
import com.example.icecream.domain.notification.service.NotificationService;

import lombok.RequiredArgsConstructor;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class CctvMessageListener {

    private final CctvMessageListenService cctvMessageListenService;
    private final RedisListenService redisListenService;
    private final NotificationService notificationService;

    @RabbitListener(queues = "hello")
    public void receiveMessage(CctvMessageDto cctvMessageDto) {
        String CrosswalkName = cctvMessageListenService.findCrosswalk(cctvMessageDto);
        List<Integer> UserArray = redisListenService.getRedisValue(CrosswalkName);
        FcmRequestDto2 fcmRequestDto2 = new FcmRequestDto2(UserArray, "CCTV", "사고 발생", "key1", "key2", "key3");
        notificationService.sendMessageToUsers(fcmRequestDto2);
    }
}
