package com.example.icecream.common.auth.service;

import com.example.icecream.common.auth.dto.*;
import com.example.icecream.common.auth.util.JwtUtil;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;
    private final JwtUtil jwtUtil;

    public LoginResponseDto deviceLogin(DeviceLoginRequestDto deviceLoginRequestDto) {

        User user = userRepository.findByDeviceId(deviceLoginRequestDto.getDeviceId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));

        if (user.getIsParent()) {
            if (jwtUtil.validateToken(deviceLoginRequestDto.getRefreshToken())) {
                List<User> children = parentChildMappingRepository.findChildrenByParentId(user.getId());

                JwtTokenDto jwtTokenDto = jwtUtil.generateTokenByController(String.valueOf(user.getId()), "ROLE_PARENT");

                return ParentLoginResponseDto.builder()
                        .username(user.getUsername())
                        .loginId(user.getLoginId())
                        .phoneNumber(user.getPhoneNumber())
                        .profileImage(user.getProfileImage())
                        .children(children)
                        .accessToken(jwtTokenDto.getAccessToken())
                        .refreshToken(jwtTokenDto.getRefreshToken())
                        .build();
            }
        }

        JwtTokenDto jwtTokenDto = jwtUtil.generateTokenByController(String.valueOf(user.getId()), "ROLE_CHILD");
        return ChildLoginResponseDto.builder()
                .username(user.getUsername())
                .phoneNumber(user.getPhoneNumber())
                .profileImage(user.getProfileImage())
                .accessToken(jwtTokenDto.getAccessToken())
                .refreshToken(jwtTokenDto.getRefreshToken())
                .build();
    }
}