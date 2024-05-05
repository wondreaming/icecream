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

    // TODO : 시큐리티 적용 후 user_id 관련 로직 수정 필요
    @GetMapping("/{user_id}")
    public ResponseEntity<ApiResponseDto<List<DestinationResponseDto>>> getDestinations(@RequestParam("user_id") Integer childId,
                                                                                        @PathVariable("user_id") Integer userId) {
        List<DestinationResponseDto> destinations = destinationService.getDestinations(userId, childId);
        return ApiResponseDto.success("목적지 조회에 성공하였습니다.", destinations);
    }

    @PostMapping("/{user_id}")
    public ResponseEntity<ApiResponseDto<String>> registerDestination(@RequestBody DestinationRegisterDto destinationRegisterDto,
                                                                      @PathVariable("user_id") Integer userId) {
        destinationService.registerDestination(userId, destinationRegisterDto);
        return ApiResponseDto.created("목적지 등록에 성공하였습니다.");
    }

    @PatchMapping("/{user_id}")
    public ResponseEntity<ApiResponseDto<String>> modifyDestination(@RequestBody DestinationModifyDto destinationModifyDto,
                                                                    @PathVariable("user_id") Integer userId) {
        destinationService.modifyDestination(userId, destinationModifyDto);
        return ApiResponseDto.success("목적지 수정에 성공하였습니다.");
    }

    @DeleteMapping("/{user_id}")
    public ResponseEntity<ApiResponseDto<String>> deleteDestination(@RequestParam("destination_id") Integer destinationId,
                                                                    @PathVariable("user_id") Integer userId) {
        destinationService.deleteDestination(userId, destinationId);
        return ApiResponseDto.success("목적지 삭제에 성공하였습니다.");
    }
}
