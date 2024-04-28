package com.example.icecream.map.service;

import com.example.icecream.map.dto.CctvMessageDto;
import org.springframework.stereotype.Service;

@Service
public class CctvMessageListenService {

    public void messageListen(CctvMessageDto cctvMessageDto) {
        System.out.println("CCTV이름 : " + cctvMessageDto.getCctvName());
        System.out.println("속도 : " + cctvMessageDto.getSpeed());
    }
}
