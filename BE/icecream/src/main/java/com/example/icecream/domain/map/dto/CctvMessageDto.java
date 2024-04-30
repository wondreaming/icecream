package com.example.icecream.domain.map.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

@Getter
public class CctvMessageDto {
    @JsonProperty("cctv_name")
    private String cctvName;
    private int speed;
}