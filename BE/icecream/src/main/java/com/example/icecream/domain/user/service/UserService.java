package com.example.icecream.domain.user.service;

import com.example.icecream.common.exception.*;
import com.example.icecream.domain.goal.service.GoalService;
import com.example.icecream.domain.notification.dto.FcmRequestDto;
import com.example.icecream.domain.notification.service.NotificationService;
import com.example.icecream.domain.user.dto.SignUpChildRequestDto;
import com.example.icecream.domain.user.dto.SignUpParentRequestDto;
import com.example.icecream.domain.user.dto.UpdateChildRequestDto;
import com.example.icecream.domain.user.entity.ParentChildMapping;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.error.UserErrorCode;
import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;

import com.example.icecream.domain.user.util.UserValidationUtils;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final ParentChildMappingRepository parentChildMappingRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserValidationUtils userValidationUtils;
    private final GoalService goalService;
    private final NotificationService notificationService;

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

        try{
            userRepository.save(user);
        } catch (RuntimeException e) {
            throw new DataConflictException(UserErrorCode.DUPLICATE_VALUE.getMessage());
        }
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
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        parent.deleteUser();
        userRepository.save(parent);
    }

    @Transactional
    public void saveChild(final SignUpChildRequestDto signUpChildRequestDto, int parentId) {
        User child = userRepository.findByDeviceId(signUpChildRequestDto.getDeviceId())
                .orElseGet(() -> {
                    try {
                        User newUser = User.builder()
                                .username(signUpChildRequestDto.getUsername())
                                .phoneNumber(signUpChildRequestDto.getPhoneNumber())
                                .deviceId(signUpChildRequestDto.getDeviceId())
                                .isParent(false)
                                .isDeleted(false)
                                .build();

                        return userRepository.save(newUser);
                    } catch (RuntimeException e) {
                        throw new BadRequestException(UserErrorCode.NOT_VALID_INPUT.getMessage());
                    }
                });

        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        ParentChildMapping parentChildMapping = ParentChildMapping.builder()
                .parent(parent)
                .child(child)
                .build();

        try {
            parentChildMappingRepository.save(parentChildMapping);
        } catch (RuntimeException e) {
            throw new BadRequestException(UserErrorCode.DUPLICATE_MAPPING.getMessage());
        }

        goalService.createGoalStatus(child.getId());

        FcmRequestDto fcmRequestDto = new FcmRequestDto(signUpChildRequestDto.getFcmToken(), "자녀 등록 알림", "자녀 등록 알림", "created");

        try {
            notificationService.sendMessageTo(fcmRequestDto);
        } catch (IOException e) {
            throw new InternalServerException(UserErrorCode.FAILED_NOTIFICATION.getMessage());
        }
    }

    public void updateChild(int parentId, final UpdateChildRequestDto signUpChildRequestDto) {
        User child = userRepository.findById(signUpChildRequestDto.getUserId())
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        if (child.getIsParent()) {
            throw new BadRequestException(UserErrorCode.NOT_CHILD.getMessage());
        }

        userValidationUtils.isValidChild(parentId, signUpChildRequestDto.getUserId());

        if (child.getUsername().equals(signUpChildRequestDto.getUsername())) {
            throw new BadRequestException(UserErrorCode.NOT_NEW_VALUE.getMessage());
        }

        child.updateUsername(signUpChildRequestDto.getUsername());
        userRepository.save(child);
    }

    @Transactional
    public void deleteChild(int parentId, int childId ) {
        userValidationUtils.isValidChild(parentId, childId);
        parentChildMappingRepository.deleteByParentIdAndChildId(parentId, childId);

        User child = userRepository.findById(childId)
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        child.deleteUser();
        userRepository.save(child);
    }

    public void checkLoginIdExists(String loginId) {
        userValidationUtils.isValidLoginId(loginId);
    }


    public void checkPassword(String currentPassword, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new BadCredentialsException(UserErrorCode.INVALID_CURRENT_PASSWORD.getMessage());
        }
    }

    public void updatePassword(String newPassword, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException(UserErrorCode.USER_NOT_FOUND.getMessage()));

        if (passwordEncoder.matches(newPassword, user.getPassword())) {
            throw new BadRequestException(UserErrorCode.NO_NEW_PASSWORD_PROVIDED.getMessage());
        }

        user.updatePassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}