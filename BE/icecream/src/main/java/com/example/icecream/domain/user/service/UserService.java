package com.example.icecream.domain.user.service;

import com.example.icecream.domain.goal.service.GoalService;
import com.example.icecream.domain.user.dto.SignUpChildRequestDto;
import com.example.icecream.domain.user.dto.SignUpParentRequestDto;
import com.example.icecream.domain.user.dto.UpdateChildRequestDto;
import com.example.icecream.domain.user.entity.ParentChildMapping;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;

import com.example.icecream.domain.user.util.UserValidationUtils;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserValidationUtils userValidationUtils;
    private final GoalService goalService;

    public void saveParent(final SignUpParentRequestDto SignUpParentRequestDto){
        userValidationUtils.isValidatePasswordCheck(SignUpParentRequestDto.getPassword(), SignUpParentRequestDto.getPasswordCheck());

        User user=User.builder()
                .username(SignUpParentRequestDto.getUsername())
                .phoneNumber(SignUpParentRequestDto.getPhoneNumber())
                .loginId(SignUpParentRequestDto.getLoginId())
                .password(passwordEncoder.encode(SignUpParentRequestDto.getPassword()))
                .deviceId(SignUpParentRequestDto.getDeviceId())
                .isParent(true)
                .isDeleted(false)
                .build();
        userRepository.save(user);
    }

    @Transactional
    public void deleteParent(int parentId) {
        userValidationUtils.isValidUser(parentId);
        List<User> children = parentChildMappingRepository.findChildrenByParentId(parentId);
        if (children != null) {
            for (User child : children) {
                child.deleteUser();
                userRepository.save(child);
            }
        }

        parentChildMappingRepository.deleteByParentId(parentId);
        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));

        parent.deleteUser();
        userRepository.save(parent);
    }


    @Transactional
    public void saveChild(final SignUpChildRequestDto signUpChildRequestDto, int parentId) {
        User child = userRepository.findByDeviceId(signUpChildRequestDto.getDeviceId())
                .orElseGet(() -> {
                    User newUser = User.builder()
                            .username(signUpChildRequestDto.getUsername())
                            .phoneNumber(signUpChildRequestDto.getPhoneNumber())
                            .deviceId(signUpChildRequestDto.getDeviceId())
                            .isParent(false)
                            .isDeleted(false)
                            .build();
                    return userRepository.save(newUser);
                });

        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));

        ParentChildMapping parentChildMapping = ParentChildMapping.builder()
                .parent(parent)
                .child(child)
                .build();

        parentChildMappingRepository.save(parentChildMapping);

        goalService.createGoalStatus(child.getId());
        //FCM으로 자녀 등록 됏다는 알림 자녀에게 보내는 메서드 호출
        //~~~~
    }

    public void updateChild(int parentId, final UpdateChildRequestDto signUpChildRequestDto) {
        User child = userRepository.findById(signUpChildRequestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("자녀가 회원이 아닙니다."));

        if (child.getIsParent()) {
            throw new IllegalArgumentException("이름을 변경하려는 대상이 부모 유저 입니다.");
        }

        userValidationUtils.isValidChild(parentId, signUpChildRequestDto.getUserId());

        child.updateUsername(signUpChildRequestDto.getUsername());
        userRepository.save(child);
    }

    @Transactional
    public void deleteChild(int parentId, int childId ) {
        userValidationUtils.isValidChild(parentId, childId);
        parentChildMappingRepository.deleteByParentIdAndChildId(parentId, childId);

        User child = userRepository.findById(childId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));

        child.deleteUser();
        userRepository.save(child);
    }

    public void checkLoginIdExists(String loginId) {
        userValidationUtils.isValidLoginId(loginId);
    }

    public void checkPassword(String currentPassword, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자가 존재하지 않습니다."));

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }
    }

    public void updatePassword(String newPassword, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자가 존재하지 않습니다."));

        if (passwordEncoder.matches(newPassword, user.getPassword())) {
            throw new IllegalArgumentException("현재와 동일한 비밀번호 입니다.");
        }

        user.updatePassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}