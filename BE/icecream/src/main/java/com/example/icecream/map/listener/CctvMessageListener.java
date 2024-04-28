package com.example.icecream.map.listener;

import com.example.icecream.map.dto.CctvMessageDto;
import com.example.icecream.map.service.CctvMessageListenService;
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
    }
}
