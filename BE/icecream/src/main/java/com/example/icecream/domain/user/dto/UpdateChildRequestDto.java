package com.example.icecream.domain.user.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import jakarta.validation.constraints.Pattern;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UpdateChildRequestDto {

    @NotNull
    private Integer userId;

    @NotBlank
    @Pattern(regexp = "^[가-힣a-zA-Z]+$", message = "사용자 이름은 한글 또는 영어로만 구성되어야 합니다.")
    private String username;

}
