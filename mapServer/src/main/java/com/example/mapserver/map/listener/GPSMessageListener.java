package com.example.mapserver.map.listener;

import com.example.mapserver.map.dto.GPSMessageDto;
import com.example.mapserver.map.service.CrosswalkService;
import com.example.mapserver.map.service.DestinationArrivalService;
import com.example.mapserver.map.service.JaywalkingCheckService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;


@RequiredArgsConstructor
@Component
@Slf4j
public class GPSMessageListener {

    private final CrosswalkService crosswalkService;
    private final DestinationArrivalService destinationArrivalService;
    private final JaywalkingCheckService jaywalkingCheckService;

    @RabbitListener(queues = "crosswalk")
    public void receiveMessage(GPSMessageDto gpsMessageDto) {
        try {
            crosswalkService.checkCrosswalkArea(gpsMessageDto.getUserId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
            destinationArrivalService.checkAndNotifyArrival(gpsMessageDto.getUserId(), gpsMessageDto.getDestinationId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
            jaywalkingCheckService.checkJaywalking(gpsMessageDto.getUserId(), gpsMessageDto.getLatitude(), gpsMessageDto.getLongitude());
        } catch (Exception e) {
//            log.error("Error processing message: {}", e.getMessage());
        }
    }
}