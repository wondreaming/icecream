package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.repository.CrosswalkCCTVMappingRepository;
import com.example.icecream.domain.map.service.CctvMessageListenService;
import com.example.icecream.domain.map.dto.CctvMessageDto;
import com.example.icecream.domain.map.service.RedisListenService;
import com.example.icecream.domain.notification.dto.FcmRequestDto2;
import com.example.icecream.domain.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
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
        cctvMessageListenService.messageListen(cctvMessageDto);
        System.out.println("Crosswalk : " + cctvMessageListenService.findCrosswalk(cctvMessageDto));
        String CrosswalkName = cctvMessageListenService.findCrosswalk(cctvMessageDto);
        List<Integer> UserArray = redisListenService.getRedisValue(CrosswalkName);
        System.out.println("UserArray : " + UserArray);
        FcmRequestDto2 fcmRequestDto2 = new FcmRequestDto2(UserArray, "CCTV", "사고 발생", "key1", "key2", "key3");
        notificationService.sendMessageToUsers(fcmRequestDto2);
    }
}
