package com.example.mapserver.map.dto;

import lombok.Data;

import java.util.List;

@Data
public class RedisMessageDto {

    private String id;
    private List<Integer> content;
}
