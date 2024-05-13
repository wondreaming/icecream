package com.example.mapserver.map.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GPSMessageDto {

    private Integer userId;
    private Integer destinationId;
    private Double latitude;
    private Double longitude;
    private String timestamp;
}
