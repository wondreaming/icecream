package com.example.icecream.domain.map.service;

import com.example.icecream.common.exception.NotFoundException;
import com.example.icecream.domain.map.dto.DestinationModifyDto;
import com.example.icecream.domain.map.dto.DestinationRegisterDto;
import com.example.icecream.domain.map.dto.DestinationResponseDto;
import com.example.icecream.domain.map.entity.Destination;
import com.example.icecream.domain.map.repository.DestinationRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DestinationServiceImpl implements DestinationService {

    private final DestinationRepository destinationRepository;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    @Override
    public List<DestinationResponseDto> getDestinations(Integer userId) {
        return destinationRepository.findAllByUserId(userId)
                .stream()
                .map(destination -> new DestinationResponseDto(
                        destination.getId(),
                        destination.getName(),
                        destination.getIcon(),
                        destination.getLatitude(),
                        destination.getLongitude(),
                        destination.getStartTime().toString(),
                        destination.getEndTime().toString(),
                        destination.getDay()
                ))
                .toList();
    }

    @Override
    @Transactional
    public void registerDestination(DestinationRegisterDto destinationRegisterDto) {
        Point location = geometryFactory.createPoint(
                new Coordinate(destinationRegisterDto.getLongitude(),
                        destinationRegisterDto.getLatitude()));

        Destination destination = Destination.builder()
                .userId(destinationRegisterDto.getUserId())
                .name(destinationRegisterDto.getName())
                .icon(destinationRegisterDto.getIcon())
                .latitude(destinationRegisterDto.getLatitude())
                .longitude(destinationRegisterDto.getLongitude())
                .startTime(destinationRegisterDto.getStartTime())
                .endTime(destinationRegisterDto.getEndTime())
                .day(destinationRegisterDto.getDay())
                .location(location)
                .radius(100.0)
                .build();

        destinationRepository.save(destination);
    }

    @Override
    public void modifyDestination(DestinationModifyDto destinationModifyDto) {
        Destination destination = destinationRepository.findById(destinationModifyDto.getDestinationId())
                .orElseThrow(() -> new NotFoundException("해당 목적지가 존재하지 않습니다."));

        Point location = geometryFactory.createPoint(
                new Coordinate(destinationModifyDto.getLongitude(),
                        destinationModifyDto.getLatitude()));

        destination.updateDestination(destinationModifyDto.getName(), destinationModifyDto.getIcon(),
                destinationModifyDto.getLatitude(), destinationModifyDto.getLongitude(),
                destinationModifyDto.getStartTime(), destinationModifyDto.getEndTime(),
                destinationModifyDto.getDay(), location);

        destinationRepository.save(destination);
    }

    @Override
    public void deleteDestination(Integer destinationId) {
        Destination destination = destinationRepository.findById(destinationId)
                .orElseThrow(() -> new NotFoundException("해당 목적지가 존재하지 않습니다."));
        destinationRepository.delete(destination);
    }
}
