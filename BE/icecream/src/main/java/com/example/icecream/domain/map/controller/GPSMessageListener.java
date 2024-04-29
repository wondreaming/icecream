package com.example.icecream.domain.map.controller;

import com.example.icecream.domain.map.dto.GPSMessageDto;
import com.example.icecream.domain.map.service.CrosswalkService;

import org.springframework.stereotype.Component;
import org.springframework.amqp.rabbit.annotation.RabbitListener;

import lombok.RequiredArgsConstructor;

import java.util.List;

@RequiredArgsConstructor
@Component
public class GPSMessageListener {

    private final CrosswalkService crosswalkService;

    @RabbitListener(queues = "crosswalk")
    public void receiveMessage(GPSMessageDto gpsMessageDto) {
        double latitude = gpsMessageDto.getLatitude();
        double longitude = gpsMessageDto.getLongitude();

        boolean roadsContainingPoint = crosswalkService.checkCrosswalkArea(latitude, longitude);
        System.out.println("Roads containing the point: " + roadsContainingPoint);
    }
}