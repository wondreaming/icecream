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

import java.util.List;

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
            System.out.println(key);
            ListOperations<String, Integer> listOperations = redisTemplate.opsForList();
            Long idx = listOperations.indexOf(key, userId);
            System.out.println("idx = " + idx);
            System.out.println("포함 여부 = " + crosswalk.getCrosswalkArea().contains(point));
            List<Integer> userIds = listOperations.range(key, 0, -1);
            System.out.println(userIds);

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