package com.example.icecream.domain.map.controller;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.map.dto.DestinationModifyDto;
import com.example.icecream.domain.map.dto.DestinationRegisterDto;
import com.example.icecream.domain.map.dto.DestinationResponseDto;
import com.example.icecream.domain.map.service.DestinationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/destination")
public class DestinationController {

    private final DestinationService destinationService;

    @GetMapping
    public ResponseEntity<ApiResponseDto<List<DestinationResponseDto>>> getDestinations(@RequestParam("user_id") Integer userId) {
        List<DestinationResponseDto> destinations = destinationService.getDestinations(userId);
        if (destinations.isEmpty()) {
            return ApiResponseDto.notFound("목적지가 존재하지 않습니다.");
        }
        return ApiResponseDto.success("목적지 조회에 성공하였습니다.", destinations);
    }

    @PostMapping
    public ResponseEntity<ApiResponseDto<String>> registerDestination(@RequestBody DestinationRegisterDto destinationRegisterDto) {
        destinationService.registerDestination(destinationRegisterDto);
        return ApiResponseDto.created("목적지 등록에 성공하였습니다.");
    }

    @PatchMapping
    public ResponseEntity<ApiResponseDto<String>> modifyDestination(@RequestBody DestinationModifyDto destinationModifyDto) {
        destinationService.modifyDestination(destinationModifyDto);
        return ApiResponseDto.success("목적지 수정에 성공하였습니다.");
    }

    @DeleteMapping
    public ResponseEntity<ApiResponseDto<String>> deleteDestination(@RequestParam("destination_id") Integer destinationId) {
        destinationService.deleteDestination(destinationId);
        return ApiResponseDto.success("목적지 삭제에 성공하였습니다.");
    }
}
