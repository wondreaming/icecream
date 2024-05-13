package com.example.mapserver.map.listener;

import com.example.mapserver.map.dto.CctvMessageDto;
import com.example.mapserver.map.service.CctvMessageListenService;
import com.example.mapserver.map.service.RedisListenService;
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
        String message = "overspeed-1";
        if (cctvMessageDto.getSpeed() >= 45) {
            message = "overspeed-3";
        } else if (cctvMessageDto.getSpeed() >= 35) {
            message = "overspeed-2";
        }
        FcmRequestDto2 fcmRequestDto2 = new FcmRequestDto2(UserArray, "\\uD83D\\uDEA8 위험 알림 \\uD83D\\uDEA8", "근처에 과속 차량이 있어요. 주의하세요!", message);
        notificationService.sendMessageToUsers(fcmRequestDto2);
    }
}
