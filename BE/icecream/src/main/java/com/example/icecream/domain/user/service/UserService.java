package com.example.icecream.domain.user.service;

import com.example.icecream.domain.user.dto.SignUpRequestDto;
import com.example.icecream.domain.user.repository.UserRepository;

import com.example.icecream.domain.user.util.UserValidationUtils;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserValidationUtils userValidationUtils;

    @Transactional
    public void saveUser(final SignUpRequestDto signUpRequestDto){
        isValidateUsername(signUpRequestDto.getUsername());
        isValidateNickname(signUpRequestDto.getPhoneNumber());
        isValidateLoginId();
        isValidatePassword();
        isValidateDeviceId();

        String hashedPassword = passwordEncoder.encode(signUpRequest.getUserPassword());

        User user=User.builder()
                .userLoginId(signUpRequest.getUserLoginId())
                .userPassword(hashedPassword)
                .userNickname(signUpRequest.getUserNickname())
                .build();
        userRepository.save(user);
    }



    private void isValidatePassword(String password, String passwordCheck) {
        String pattern = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9!@#$%^&*]{8,16}$";
        String pattern2 = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d!?@#$%^&*]{8,}$";


        if(!password.matches(pattern)||!password.matches(pattern2)){
            throw new IllegalArgumentException("비밀번호는 영문과 숫자, 허용되는 특수문자를 포함한 8 ~ 16자만 가능합니다.");
        }

        if (!password.equals(passwordCheck) || password.trim().isEmpty() || passwordCheck.trim().isEmpty()){
            throw new IllegalArgumentException("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        }
    }

    public void isValidateLoginId(String userLoginId) {
        String pattern = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,10}$";
        if (!userLoginId.matches(pattern)) {
            throw new IllegalArgumentException("아이디는 영문과 숫자를 포함한 6 ~ 10자만 가능합니다.");
        }

        Optional<User> user = userRepository.findByUserLoginId(userLoginId);

        if (user.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 아이디 입니다.");
        }
    }

    public void isValidateNickname(String nickname) {
        String pattern = "^[가-힣a-zA-Z0-9]{2,8}$";

        if (!nickname.matches(pattern)) {
            throw new IllegalArgumentException("닉네임 규칙에 맞지 않습니다.");
        }

        Optional<User> user = userRepository.findByUserNickname(nickname);
        if (user.isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 닉네임 입니다.");
        }
    }

    @Transactional
    public void updateNickname(final String userNickname,final int userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        isValidateNickname(userNickname);
        user.updateNickname(userNickname);
        userRepository.save(user);
    }

    @Transactional
    public void updatePassword(final UpdatePasswordRequest userPassword, final int userId) {

        String currentPassword = userPassword.getCurrentPassword();
        String newPassword = userPassword.getNewPassword();

        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        if (!passwordEncoder.matches(currentPassword, user.getUserPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }

        String encodedNewPassword = passwordEncoder.encode(newPassword);

        user.updatePassword(encodedNewPassword);
        userRepository.save(user);
    }
}