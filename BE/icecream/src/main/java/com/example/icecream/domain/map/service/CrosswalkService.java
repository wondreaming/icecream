package com.example.icecream.domain.map.service;

import com.example.icecream.domain.map.entity.Crosswalk;
import com.example.icecream.domain.map.repository.CrosswalkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Point;


@Service
public class CrosswalkService {

    private final CrosswalkRepository crosswalkRepository;
    private final RedisTemplate<String, Integer> redisTemplate;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    @Autowired
    public CrosswalkService(CrosswalkRepository crosswalkRepository, RedisTemplate<String, Integer> redisTemplate) {
        this.crosswalkRepository = crosswalkRepository;
        this.redisTemplate = redisTemplate;
    }

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