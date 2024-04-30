package com.example.icecream.domain.map.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RedisListenService {

    private final RedisTemplate<String, List<Integer>> redisTemplate;

    @Autowired
    public RedisListenService(RedisTemplate<String, List<Integer>> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public List<Integer> getRedisValue(String key) {
        return redisTemplate.opsForValue().get(key);
    }
}
