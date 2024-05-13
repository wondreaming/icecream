package com.example.mapserver.map.service;

import com.example.mapserver.map.dto.CctvMessageDto;
import com.example.mapserver.map.entity.CrosswalkCCTVMapping;
import com.example.mapserver.map.repository.CrosswalkCCTVMappingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CctvMessageListenService {

    private final CrosswalkCCTVMappingRepository crosswalkCCTVMappingRepository;

    public String findCrosswalk(CctvMessageDto cctvMessageDto) {
        CrosswalkCCTVMapping crosswalkCCTVMapping = crosswalkCCTVMappingRepository.findCrosswalkCCTVMappingByCctvName(cctvMessageDto.getCctvName());
        return crosswalkCCTVMapping.getCrosswalkName();
    }
}

