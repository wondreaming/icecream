package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.dto.GPSMessageDto;
import com.example.icecream.domain.map.service.CrosswalkService;

import org.springframework.stereotype.Component;
import org.springframework.amqp.rabbit.annotation.RabbitListener;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Component
public class GPSMessageListener {

    private final CrosswalkService crosswalkService;

    @RabbitListener(queues = "crosswalk")
    public void receiveMessage(GPSMessageDto gpsMessageDto) {
        crosswalkService.checkCrosswalkArea(gpsMessageDto.getUserId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
    }
}