package com.example.mapserver.map.service;

import com.example.common.config.GeometryConfig;
import com.example.mapserver.map.entity.Crosswalk;
import com.example.mapserver.map.repository.CrosswalkRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.context.annotation.Import;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Import(GeometryConfig.class)
public class CrosswalkService {

    private final CrosswalkRepository crosswalkRepository;
    private final RedisTemplate<String, Integer> redisTemplate;
    private final GeometryFactory geometryFactory;

    public void checkCrosswalkArea(int userId, double latitude, double longitude) {
        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        for (Crosswalk crosswalk : crosswalkRepository.findAll()) {
            String key = crosswalk.getCrosswalkName();
            ListOperations<String, Integer> listOperations = redisTemplate.opsForList();
            Long idx = listOperations.indexOf(key, userId);

            if (crosswalk.getCrosswalkArea().contains(point)) {
                if (idx == null) {
                    listOperations.rightPush(key, userId);
                }
            } else {
                if (idx != null) {
                    listOperations.remove(key, 0, userId);
                }
            }
        }
    }
}