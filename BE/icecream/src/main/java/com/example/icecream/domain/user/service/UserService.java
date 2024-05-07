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

    @Transactional
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

        goalService.createGoalStatus(user.getId());
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

        // FCM 토큰으로 알림 보내는 메서드 호출하기
        //        FcmToken fcmToken = FcmToken.builder()
        //             .userId()

        User child=User.builder()
                .username(signUpChildRequestDto.getUsername())
                .phoneNumber(signUpChildRequestDto.getPhoneNumber())
                .deviceId(signUpChildRequestDto.getDeviceId())
                .isParent(false)
                .isDeleted(false)
                .build();

        userRepository.save(child);

        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다.") );

        ParentChildMapping parentChildMapping = ParentChildMapping.builder()
                .parent(parent)
                .child(child)
                .build();

        parentChildMappingRepository.save(parentChildMapping);
    }

    public void updateChild(int parentId, final UpdateChildRequestDto signUpChildRequestDto) {
        userValidationUtils.isValidChild(parentId, signUpChildRequestDto.getUserId());

        User child = userRepository.findById(signUpChildRequestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저 입니다."));

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


//    @Transactional
//    public void updatePassword(final UpdatePasswordRequest userPassword, final int userId) {
//
//        String currentPassword = userPassword.getCurrentPassword();
//        String newPassword = userPassword.getNewPassword();
//
//        User user = userRepository.findByUserId(userId)
//                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
//
//        if (!passwordEncoder.matches(currentPassword, user.getUserPassword())) {
//            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
//        }
//
//        String encodedNewPassword = passwordEncoder.encode(newPassword);
//
//        user.updatePassword(encodedNewPassword);
//        userRepository.save(user);
//    }
}