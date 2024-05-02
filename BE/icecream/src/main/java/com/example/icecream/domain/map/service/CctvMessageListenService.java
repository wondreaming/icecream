package com.example.icecream.domain.map.service;

import com.example.icecream.domain.map.dto.CctvMessageDto;
import com.example.icecream.domain.map.entity.CrosswalkCCTVMapping;
import com.example.icecream.domain.map.repository.CrosswalkCCTVMappingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CctvMessageListenService {

    private final CrosswalkCCTVMappingRepository crosswalkCCTVMappingRepository;

    public void messageListen(CctvMessageDto cctvMessageDto) {
        System.out.println("CCTV이름 : " + cctvMessageDto.getCctvName());
        System.out.println("속도 : " + cctvMessageDto.getSpeed());
    }

    public String findCrosswalk(CctvMessageDto cctvMessageDto) {
        CrosswalkCCTVMapping crosswalkCCTVMapping = crosswalkCCTVMappingRepository.findCrosswalkCCTVMappingByCctvName(cctvMessageDto.getCctvName());
        return crosswalkCCTVMapping.getCrosswalkName();
    }
}

