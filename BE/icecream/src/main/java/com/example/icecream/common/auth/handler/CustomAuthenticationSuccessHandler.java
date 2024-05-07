package com.example.icecream.common.auth.handler;

import com.example.icecream.common.auth.dto.JwtTokenDto;
import com.example.icecream.common.auth.dto.ParentLoginResponseDto;
import com.example.icecream.common.auth.util.JwtUtil;
import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final ObjectMapper objectMapper;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        User user = userRepository.findByLoginId(authentication.getName()).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));
        List<User> children = parentChildMappingRepository.findChildrenByParentId(user.getId());

        JwtTokenDto jwtToken = jwtUtil.generateTokenByFilterChain(authentication, user.getId());

        ParentLoginResponseDto parentLoginResponseDto = ParentLoginResponseDto.builder()
                .username(user.getUsername())
                .loginId(user.getLoginId())
                .phoneNumber(user.getPhoneNumber())
                .profileImage(user.getProfileImage())
                .children(children)
                .accessToken(jwtToken.getAccessToken())
                .refreshToken(jwtToken.getRefreshToken())
                .build();

        ApiResponseDto<ParentLoginResponseDto> apiResponse = new ApiResponseDto<>(200, "로그인 되었습니다.", parentLoginResponseDto);

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
        response.getWriter().flush();
    }
}
