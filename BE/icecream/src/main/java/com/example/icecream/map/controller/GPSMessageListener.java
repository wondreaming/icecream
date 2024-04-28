package com.example.icecream.map.controller;

import com.example.icecream.map.service.CrosswalkService;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class GPSMessageListener {

    private final CrosswalkService crosswalkService;

    @Autowired
    public GPSMessageListener(CrosswalkService crosswalkService) {
        this.crosswalkService = crosswalkService;
    }

    @RabbitListener(queues = "crosswalk")
    public void receiveMessage(String gpsDataRequest) {
        System.out.println("Received message: " + gpsDataRequest);
    }
}
