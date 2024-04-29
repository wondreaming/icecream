package com.example.icecream.domain.map.service;

import com.example.icecream.domain.map.entity.Crosswalk;
import com.example.icecream.domain.map.repository.CrosswalkRepository;
import org.springframework.beans.factory.annotation.Autowired;
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


    public boolean checkCrosswalkArea(double latitude, double longitude) {

        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        for (Crosswalk crosswalk : crosswalkRepository.findAll()) {
            boolean isWithin = crosswalk.getCrosswalkArea().contains(point);
            List<String> list = Arrays.asList("a", "b", "c");
            redisTemplate.opsForValue().set("abc", list);
            System.out.println(redisTemplate.opsForValue().get("abc"));
//            if (isWithin && valueFromRedis != null && valueFromRedis.equals("True")) {
//                return true; // 포함되고, 레디스 값이 True면 true 반환
//            } else if (!isWithin && valueFromRedis != null && valueFromRedis.equals("False")) {
//                return true; // 포함되지 않고, 레디스 값이 False면 true 반환
//            }
        }
        return false; // 모든 순회에서 조건을 만족하지 못하면 false 반환
    }
}