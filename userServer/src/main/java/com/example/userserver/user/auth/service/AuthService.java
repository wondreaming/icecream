package com.example.userserver.user.auth.service;

import com.example.common.exception.NotFoundException;
import com.example.icecream.domain.notification.dto.LoginRequestDto;
import com.example.icecream.domain.notification.service.NotificationService;
import com.example.userserver.user.auth.dto.*;
import com.example.userserver.user.auth.error.AuthErrorCode;
import com.example.userserver.user.auth.util.JwtUtil;
import com.example.userserver.user.entity.User;
import com.example.userserver.user.repository.ParentChildMappingRepository;
import com.example.userserver.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;
    private final JwtUtil jwtUtil;
    private final NotificationService notificationService;

    public LoginResponseDto deviceLogin(DeviceLoginRequestDto deviceLoginRequestDto) {

        User user = userRepository.findByDeviceIdAndIsDeletedFalse(deviceLoginRequestDto.getDeviceId())
                .orElseThrow(() -> new NotFoundException(AuthErrorCode.USER_NOT_FOUND.getMessage()));

        if (user.getIsParent()) {
            if (jwtUtil.validateRefreshToken(deviceLoginRequestDto.getRefreshToken(), String.valueOf(user.getId()))) {
                List<User> children = parentChildMappingRepository.findChildrenByParentId(user.getId());

                List<ChildrenResponseDto> childrenResponseDto = children.stream()
                        .map(child -> new ChildrenResponseDto(child.getId(), child.getProfileImage(), child.getUsername(), child.getPhoneNumber()))
                        .toList();

                JwtTokenDto jwtTokenDto = jwtUtil.generateTokenByController(String.valueOf(user.getId()), "ROLE_PARENT");

                LoginRequestDto loginRequestDto = new LoginRequestDto(user.getId(), deviceLoginRequestDto.getFcmToken());
                notificationService.saveOrUpdateFcmToken(loginRequestDto);

                return ParentLoginResponseDto.builder()
                        .username(user.getUsername())
                        .loginId(user.getLoginId())
                        .phoneNumber(user.getPhoneNumber())
                        .profileImage(user.getProfileImage())
                        .children(childrenResponseDto)
                        .accessToken(jwtTokenDto.getAccessToken())
                        .refreshToken(jwtTokenDto.getRefreshToken())
                        .build();
            }
        }

        JwtTokenDto jwtTokenDto = jwtUtil.generateTokenByController(String.valueOf(user.getId()), "ROLE_CHILD");
        LoginRequestDto loginRequestDto = new LoginRequestDto(user.getId(), deviceLoginRequestDto.getFcmToken());
        notificationService.saveOrUpdateFcmToken(loginRequestDto);

        return ChildLoginResponseDto.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .phoneNumber(user.getPhoneNumber())
                .profileImage(user.getProfileImage())
                .accessToken(jwtTokenDto.getAccessToken())
                .refreshToken(jwtTokenDto.getRefreshToken())
                .build();
    }
}