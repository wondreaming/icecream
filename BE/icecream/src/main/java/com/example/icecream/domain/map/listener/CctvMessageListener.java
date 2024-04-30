package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.repository.CrosswalkCCTVMappingRepository;
import com.example.icecream.domain.map.service.CctvMessageListenService;
import com.example.icecream.domain.map.dto.CctvMessageDto;
import com.example.icecream.domain.map.service.RedisListenService;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class CctvMessageListener {

    private final CctvMessageListenService cctvMessageListenService;
    private final RedisListenService redisListenService;

    @RabbitListener(queues = "hello")
    public void receiveMessage(CctvMessageDto cctvMessageDto) {
        cctvMessageListenService.messageListen(cctvMessageDto);
        System.out.println("Crosswalk : " + cctvMessageListenService.findCrosswalk(cctvMessageDto));
        String CrosswalkName = cctvMessageListenService.findCrosswalk(cctvMessageDto);
        Object UserArray = redisListenService.getRedisValue(CrosswalkName);
        System.out.println("UserArray : " + UserArray);
    }
}
