package com.example.icecream.common.auth.util;

import com.example.icecream.common.auth.dto.JwtTokenDto;
import com.example.icecream.common.auth.error.AuthErrorCode;
import com.example.icecream.common.exception.NotFoundException;
import com.example.icecream.domain.user.repository.UserRepository;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.ObjectUtils;

import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;


@Component
@RequiredArgsConstructor
@Slf4j
public class JwtUtil {

    @Value("${com.icecream.auth.access.secretKey}")
    private String accessSecretKey;
    @Value("${com.icecream.auth.refresh.secretKey}")
    private String refreshSecretKey;
    private final RedisTemplate<String, String> redisTemplate;

    public JwtTokenDto generateTokenByFilterChain(Authentication authentication, int userId) {
        byte[] accessSigningKey = accessSecretKey.getBytes();
        byte[] refreshSigningKey = refreshSecretKey.getBytes();

        String authority = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        long now = (new Date()).getTime();

        Date accessTokenExpiresIn = new Date(now + 28800000);
        String accessToken = Jwts.builder()
                .setSubject(String.valueOf(userId))
                .claim("authority", authority)
                .setExpiration(accessTokenExpiresIn)
                .signWith(Keys.hmacShaKeyFor(accessSigningKey), SignatureAlgorithm.HS256)
                .compact();


        Date refreshTokenExpiresIn = new Date(now + 43200000);
        String refreshToken = Jwts.builder()
                .setSubject(String.valueOf(userId))
                .setExpiration(refreshTokenExpiresIn)
                .claim("authority", authority)
                .signWith(Keys.hmacShaKeyFor(refreshSigningKey), SignatureAlgorithm.HS256)
                .compact();

        saveRefreshToken(String.valueOf(userId), refreshToken);

        return JwtTokenDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    public JwtTokenDto generateTokenByController(String userId, String authority) {
        byte[] accessSigningKey = accessSecretKey.getBytes();
        byte[] refreshSigningKey = refreshSecretKey.getBytes();

        long now = (new Date()).getTime();

        Date accessTokenExpiresIn = new Date(now + 28800000);
        String accessToken = Jwts.builder()
                .setSubject(userId)
                .claim("authority", authority)
                .setExpiration(accessTokenExpiresIn)
                .signWith(Keys.hmacShaKeyFor(accessSigningKey), SignatureAlgorithm.HS256)
                .compact();


        Date refreshTokenExpiresIn = new Date(now + 43200000);
        String refreshToken = Jwts.builder()
                .setSubject(userId)
                .setExpiration(refreshTokenExpiresIn)
                .claim("authority", authority)
                .signWith(Keys.hmacShaKeyFor(refreshSigningKey), SignatureAlgorithm.HS256)
                .compact();

        saveRefreshToken(userId, refreshToken);

        return JwtTokenDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    // Jwt 토큰을 복호화하여 토큰에 들어있는 정보를 꺼내는 메서드
    public Authentication getAuthentication(String accessToken) {

        Claims claims = parseAccessClaims(accessToken);

        if (claims.get("authority") == null) {
            throw new BadCredentialsException(AuthErrorCode.INVALID_TOKEN.getMessage());
        }

        Collection<? extends GrantedAuthority> authorities = Arrays.stream(claims.get("authority").toString().split(","))
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        UserDetails principal = new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }

    // 토큰 정보를 검증하는 메서드
    public boolean validateAccessToken(String token) {
        try {
            byte[] accessSigningKey = accessSecretKey.getBytes();

            Jwts.parserBuilder()
                    .setSigningKey(Keys.hmacShaKeyFor(accessSigningKey))
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            throw new BadCredentialsException(AuthErrorCode.INVALID_TOKEN.getMessage());
        }
    }

    public boolean validateRefreshToken(String token) {
        try {
            byte[] refreshSigningKey = refreshSecretKey.getBytes();

            Jwts.parserBuilder()
                    .setSigningKey(Keys.hmacShaKeyFor(refreshSigningKey))
                    .build()
                    .parseClaimsJws(token);
            return true;

        } catch (Exception e) {
            throw new BadCredentialsException(AuthErrorCode.INVALID_TOKEN.getMessage());
        }
    }

    public JwtTokenDto reissueToken(String refreshToken) {
        validateRefreshToken(refreshToken);

        Claims claims = parseRefreshClaims(refreshToken);
        String userId = claims.getSubject();
        String authority = claims.get("authority", String.class);

        String redisRefreshToken = findRefreshTokenInRedis(userId);

        if (ObjectUtils.isEmpty(redisRefreshToken)) {
            throw new BadCredentialsException(AuthErrorCode.NO_TOKEN_IN_REDIS.getMessage());
        }
        if (!redisRefreshToken.equals(refreshToken)) {
            throw new BadCredentialsException(AuthErrorCode.NO_TOKEN_IN_REDIS.getMessage());
        }

        return generateTokenByController(userId,authority);
    }

    private Claims parseAccessClaims(String accessToken) {
        try {
            byte[] accessSigningKey = accessSecretKey.getBytes();

            return Jwts.parserBuilder()
                    .setSigningKey(Keys.hmacShaKeyFor(accessSigningKey))
                    .build()
                    .parseClaimsJws(accessToken)
                    .getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }

    private Claims parseRefreshClaims(String accessToken) {
        try {
            byte[] refreshSigningKey = refreshSecretKey.getBytes();
            return Jwts.parserBuilder()
                    .setSigningKey(Keys.hmacShaKeyFor(refreshSigningKey))
                    .build()
                    .parseClaimsJws(accessToken)
                    .getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }

    public void saveRefreshToken(String userId, String refreshToken) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set("refreshToken:" + userId, refreshToken, 12, TimeUnit.HOURS);
    }

    public String findRefreshTokenInRedis(String userId) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        return valueOperations.get("refreshToken:" + userId);
    }

    public void invalidateRefreshToken(String userId) {
        redisTemplate.delete("refreshToken:" + userId);
    }
}