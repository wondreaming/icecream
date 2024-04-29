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

import java.util.Arrays;
import java.util.List;

@Service
public class CrosswalkService {

    private final CrosswalkRepository crosswalkRepository;
    private final RedisTemplate<String, Object> redisTemplate;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    @Autowired
    public CrosswalkService(CrosswalkRepository crosswalkRepository, RedisTemplate<String, Object> redisTemplate) {
        this.crosswalkRepository = crosswalkRepository;
        this.redisTemplate = redisTemplate;
    }


    public void checkCrosswalkArea(int userId, double latitude, double longitude) {
        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        ListOperations<String, Object> listOps = redisTemplate.opsForList();

        for (Crosswalk crosswalk : crosswalkRepository.findAll()) {
            String key = crosswalk.getCrosswalkName();
            long index = listOps.indexOf(key, userId);

            if (crosswalk.getCrosswalkArea().contains(point)) {
                if (index == -1) {
                    listOps.rightPush(key, String.valueOf(userId));
                }

            } else {
                if (index != -1) {
                    listOps.remove(key, 0, String.valueOf(userId));
                }

            }
        }

    }
}