package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.repository.CrosswalkCCTVMappingRepository;
import com.example.icecream.domain.map.service.CctvMessageListenService;
import com.example.icecream.domain.map.dto.CctvMessageDto;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CctvMessageListener {

    @Autowired
    private CctvMessageListenService cctvMessageListenService;

    @RabbitListener(queues = "hello")
    public void receiveMessage(CctvMessageDto cctvMessageDto) {
        cctvMessageListenService.messageListen(cctvMessageDto);
        System.out.println("Crosswalk : " + cctvMessageListenService.findCrosswalk(cctvMessageDto));
    }
}
