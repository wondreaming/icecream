package com.example.icecream.domain.map.service;

import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.map.entity.Crosswalk;
import com.example.icecream.domain.map.entity.Road;
import com.example.icecream.domain.map.repository.CrosswalkRepository;
import com.example.icecream.domain.map.repository.RoadRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class JaywalkingCheckService {

    private final RoadRepository roadRepository;
    private final GeometryFactory geometryFactory;
    private final RedisTemplate<String, Integer> redisTemplate;
    private final GoalStatusRepository goalStatusRepository;

    public void checkJaywalking(int userId, double latitude, double longitude) {
        ValueOperations<String, Integer> ops = redisTemplate.opsForValue();
        Integer dailyGoal = ops.get("user_goal:" + userId);
        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        for (Road road : roadRepository.findAll()) {
            if (road.getRoadArea().contains(point)) {
                if (dailyGoal == 0) {
                    GoalStatus goalStatus = goalStatusRepository.findByUserId(userId);
                    goalStatus.getResult().put(LocalDate.now(), -1);
                    goalStatusRepository.save(goalStatus);

                    ops.set("user_goal:" + userId, 1);
                }

                // 알림 로직
                return;


            }
        }

    }
}
