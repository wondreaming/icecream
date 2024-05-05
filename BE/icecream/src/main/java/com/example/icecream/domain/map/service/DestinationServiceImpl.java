package com.example.icecream.domain.map.service;

import com.example.icecream.common.exception.DataAccessException;
import com.example.icecream.common.exception.NotFoundException;
import com.example.icecream.common.service.CommonService;
import com.example.icecream.domain.map.dto.DestinationModifyDto;
import com.example.icecream.domain.map.dto.DestinationRegisterDto;
import com.example.icecream.domain.map.dto.DestinationResponseDto;
import com.example.icecream.domain.map.entity.Destination;
import com.example.icecream.domain.map.repository.DestinationRepository;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional(readOnly = true)
@Service
public class DestinationServiceImpl extends CommonService implements DestinationService {

    private final DestinationRepository destinationRepository;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    public DestinationServiceImpl(UserRepository userRepository,
                                  ParentChildMappingRepository parentChildMappingRepository,
                                  DestinationRepository destinationRepository) {
        super(userRepository, parentChildMappingRepository);
        this.destinationRepository = destinationRepository;
    }

    @Override
    public List<DestinationResponseDto> getDestinations(Integer userId, Integer childId) {
        if (!isUserExist(childId)) {
            throw new NotFoundException("해당 사용자가 존재하지 않습니다.");
        }

        if (!isParentUserWithPermission(userId, childId) && !userId.equals(childId)) {
            throw new DataAccessException("목적지 조회 권한이 없습니다.");
        }

        return destinationRepository.findAllByUserId(childId)
                .stream()
                .map(destination -> new DestinationResponseDto(
                        destination.getId(),
                        destination.getName(),
                        destination.getIcon(),
                        destination.getLatitude(),
                        destination.getLongitude(),
                        destination.getStartTime(),
                        destination.getEndTime(),
                        destination.getDay()
                ))
                .toList();
    }

    @Override
    @Transactional
    public void registerDestination(Integer userId, DestinationRegisterDto destinationRegisterDto) {
        if (!isParentUserWithPermission(userId, destinationRegisterDto.getUserId())) {
            throw new DataAccessException("목적지 등록 권한이 없습니다.");
        }
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
    @Transactional
    public void modifyDestination(Integer userId, DestinationModifyDto destinationModifyDto) {
        Destination destination = destinationRepository.findById(destinationModifyDto.getDestinationId())
                .orElseThrow(() -> new NotFoundException("해당 목적지가 존재하지 않습니다."));

        if (!isParentUserWithPermission(userId, destination.getUserId())) {
            throw new DataAccessException("목적지 수정 권한이 없습니다.");
        }

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
    @Transactional
    public void deleteDestination(Integer userId, Integer destinationId) {
        Destination destination = destinationRepository.findById(destinationId)
                .orElseThrow(() -> new NotFoundException("해당 목적지가 존재하지 않습니다."));

        if (!isParentUserWithPermission(userId, destination.getUserId())) {
            throw new DataAccessException("목적지 삭제 권한이 없습니다.");
        }

        destinationRepository.delete(destination);
    }
}
