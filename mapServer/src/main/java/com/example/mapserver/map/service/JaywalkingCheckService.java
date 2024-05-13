package com.example.mapserver.map.service;

import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.entity.Goal;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.goal.repository.postgres.GoalRepository;
import com.example.mapserver.map.entity.Road;
import com.example.mapserver.map.repository.RoadRepository;
import com.example.icecream.domain.notification.document.FcmToken;
import com.example.icecream.domain.notification.dto.FcmRequestDto;
import com.example.icecream.domain.notification.repository.FcmTokenRepository;
import com.example.icecream.domain.notification.service.NotificationService;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class JaywalkingCheckService {

    private final RoadRepository roadRepository;
    private final GeometryFactory geometryFactory;
    private final RedisTemplate<String, Integer> redisTemplate;
    private final GoalStatusRepository goalStatusRepository;
    private final GoalRepository goalRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;
    private final UserRepository userRepository;
    private final FcmTokenRepository fcmTokenRepository;
    private final NotificationService notificationService;

    public void checkJaywalking(int userId, double latitude, double longitude) throws IOException {
        ValueOperations<String, Integer> ops = redisTemplate.opsForValue();
        Integer dailyGoal = ops.get("user_goal:" + userId);
        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        for (Road road : roadRepository.findAll()) {
            if (road.getRoadArea().contains(point)) {
                if (dailyGoal == null || dailyGoal == 0) {
                    GoalStatus goalStatus = goalStatusRepository.findByUserId(userId);
                    goalStatus.getResult().put(LocalDate.now(), -1);
                    goalStatusRepository.save(goalStatus);

                    Goal goal = goalRepository.findByUserIdAndIsActive(userId, true);
                    goal.updateRecord(0);
                    goalRepository.save(goal);

                    int parentId = parentChildMappingRepository.findByChildId(userId).getParent().getId();
                    User user = userRepository.findById(userId).orElseThrow();
                    FcmToken fcmToken = fcmTokenRepository.findByUserId(parentId);
                    FcmRequestDto fcmRequestDto = new FcmRequestDto(fcmToken.getToken(), "목표 달성 현황 초기화", user.getUsername() + "님이 무단횡단하였습니다.", "goal");
                    notificationService.sendMessageTo(fcmRequestDto);

                    ops.set("user_goal:" + userId, 1);
                }
            }
        }
    }
}
