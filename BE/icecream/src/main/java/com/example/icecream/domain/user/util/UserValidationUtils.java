package com.example.icecream.domain.user.util;

import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
public class UserValidationUtils {
    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;

    public void isValidUser(int userId) {
        Optional<User> user = userRepository.findByIdAndIsDeletedFalse(userId);
        if (user.isEmpty()) {
            throw new IllegalArgumentException("등록된 회원이 아닙니다.");
        }
    }

    public void isValidLoginId(String loginId) {
        if (userRepository.existsByLoginId(loginId)) {
            throw new IllegalArgumentException("이미 사용 중인 로그인 ID 입니다.");
        }
    }

    public void isValidatePasswordCheck(String password, String passwordCheck) {
        if (!password.equals(passwordCheck)) {
            throw new IllegalArgumentException("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        }
    }

    public void isValidChild(int parentId,int childId){
        if (!parentChildMappingRepository.existsByParentIdAndChildId(parentId, childId)) {
            throw new IllegalArgumentException("현재 부모에 등록된 자녀가 아닙니다.");
        }
    }
}
