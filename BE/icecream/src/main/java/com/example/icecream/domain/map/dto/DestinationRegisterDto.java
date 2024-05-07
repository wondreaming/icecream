package com.example.icecream.domain.map.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class DestinationRegisterDto {

    private Integer userId;
    private String name;
    private Integer icon;
    private Double latitude;
    private Double longitude;
    private LocalTime startTime;
    private LocalTime endTime;
    private String day;
}
