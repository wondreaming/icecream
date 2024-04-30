package com.example.icecream.domain.map.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
@NoArgsConstructor
@Getter
@ToString
public class GPSMessageDto {

    private int userId;
    private int destinationId;
    private double latitude;
    private double longitude;
    private String timestamp;
}
