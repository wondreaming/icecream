package com.example.icecream.domain.map.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalTime;

@Getter
@AllArgsConstructor
public class DestinationResponseDto {

    private Integer destinationId;
    private String name;
    private Integer icon;
    private Double latitude;
    private Double longitude;
    private String startTime;
    private String endTime;
    private String day;
}
