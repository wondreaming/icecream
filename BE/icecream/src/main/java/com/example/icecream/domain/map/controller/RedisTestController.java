package com.example.icecream.domain.map.controller;

import com.example.icecream.domain.map.dto.RedisMessageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class RedisTestController {

    private final RedisTemplate<String, List<Integer>> redisTemplate;
    @PostMapping("/redis")
    public void RedisTest(@RequestBody RedisMessageDto redisMessageDto) {
        redisTemplate.opsForValue().set(redisMessageDto.getId(), redisMessageDto.getContent());
    }

}
