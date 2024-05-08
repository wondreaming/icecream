package com.example.icecream.domain.map.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@NoArgsConstructor
public class GPSMessageDto {

    private Integer userId;
    private Integer destinationId;
    private Double latitude;
    private Double longitude;
    private String timestamp;
}
