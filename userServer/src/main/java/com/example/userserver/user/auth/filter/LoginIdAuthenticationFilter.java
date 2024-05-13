package com.example.userserver.user.auth.filter;

import com.example.common.exception.BadRequestException;
import com.example.common.exception.InternalServerException;
import com.example.userserver.user.auth.dto.LoginRequestDto;
import com.example.userserver.user.auth.error.AuthErrorCode;
import com.example.userserver.user.auth.handler.CustomAuthenticationSuccessHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class LoginIdAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private final ObjectMapper objectMapper;

    public LoginIdAuthenticationFilter(AuthenticationManager authenticationManager, CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler, ObjectMapper objectMapper) {
        super(authenticationManager);
        super.setAuthenticationSuccessHandler(customAuthenticationSuccessHandler);
        this.objectMapper = objectMapper;
        setFilterProcessesUrl("/auth/login");
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        if (!request.getMethod().equals("POST")) {
            throw new BadRequestException(AuthErrorCode.INVALID_HTTP_METHOD.getMessage());
        }

        try {
            LoginRequestDto loginRequestDto = objectMapper.readValue(request.getInputStream(), LoginRequestDto.class);
            request.setAttribute("fcmToken", loginRequestDto.getFcmToken());
            UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                    new UsernamePasswordAuthenticationToken(loginRequestDto.getLoginId(),loginRequestDto.getPassword());
            return  getAuthenticationManager().authenticate(usernamePasswordAuthenticationToken);

        } catch (IOException ex) {
            throw new InternalServerException(AuthErrorCode.INPUT_SERIALIZE_FAIL.getMessage());
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {
        getSuccessHandler().onAuthenticationSuccess(request, response, authResult);
    }
}