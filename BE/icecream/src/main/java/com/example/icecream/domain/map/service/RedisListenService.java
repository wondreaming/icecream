package com.example.icecream.domain.map.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class RedisListenService {

    private final RedisTemplate<String, Object> redisTemplate;

    @Autowired
    public RedisListenService(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public Object getRedisValue(String key) {
        return redisTemplate.opsForValue().get(key);
    }
}
