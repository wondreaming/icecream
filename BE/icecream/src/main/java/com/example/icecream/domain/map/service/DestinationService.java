package com.example.icecream.domain.map.service;

import com.example.icecream.domain.map.dto.DestinationModifyDto;
import com.example.icecream.domain.map.dto.DestinationRegisterDto;
import com.example.icecream.domain.map.dto.DestinationResponseDto;

import java.util.List;

public interface DestinationService {

    public List<DestinationResponseDto> getDestinations(Integer userId);
    public void registerDestination(DestinationRegisterDto destinationRegisterDto);
    public void modifyDestination(DestinationModifyDto destinationModifyDto);
    public void deleteDestination(Integer destinationId);
}
