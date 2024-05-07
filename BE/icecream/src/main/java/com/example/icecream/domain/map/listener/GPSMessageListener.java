package com.example.icecream.domain.map.listener;

import com.example.icecream.domain.map.dto.GPSMessageDto;
import com.example.icecream.domain.map.service.CrosswalkService;

import com.example.icecream.domain.map.service.DestinationArrivalService;
import org.springframework.stereotype.Component;
import org.springframework.amqp.rabbit.annotation.RabbitListener;

import lombok.RequiredArgsConstructor;

import java.io.IOException;

@RequiredArgsConstructor
@Component
public class GPSMessageListener {

    private final CrosswalkService crosswalkService;
    private final DestinationArrivalService destinationArrivalService;

    @RabbitListener(queues = "crosswalk")
    public void receiveMessage(GPSMessageDto gpsMessageDto) throws IOException {
        crosswalkService.checkCrosswalkArea(gpsMessageDto.getUserId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
        destinationArrivalService.checkAndNotifyArrival(gpsMessageDto.getUserId(), gpsMessageDto.getDestinationId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
    }
}