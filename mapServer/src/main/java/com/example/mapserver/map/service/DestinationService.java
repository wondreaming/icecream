package com.example.mapserver.map.service;

import com.example.mapserver.map.dto.DestinationModifyDto;
import com.example.mapserver.map.dto.DestinationRegisterDto;
import com.example.mapserver.map.dto.DestinationResponseDto;

import java.util.List;

public interface DestinationService {

    List<DestinationResponseDto> getDestinations(Integer userId, Integer childId);
    void registerDestination(Integer userId, DestinationRegisterDto destinationRegisterDto);
    void modifyDestination(Integer userId, DestinationModifyDto destinationModifyDto);
    void deleteDestination(Integer userId, Integer destinationId);
}
