package com.example.icecream.domain.user.controller;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.user.dto.SignUpChildRequestDto;
import com.example.icecream.domain.user.dto.SignUpParentRequestDto;
import com.example.icecream.domain.user.service.UserService;
import com.example.icecream.domain.user.dto.PasswordRequestDto;
import com.example.icecream.domain.user.dto.UpdateChildRequestDto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;

import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    @PostMapping
    public ResponseEntity<ApiResponseDto<String>> signup(@RequestBody @Valid SignUpParentRequestDto signUpParentRequestDto){
        userService.saveParent(signUpParentRequestDto);
        return ApiResponseDto.created("회원 가입에 성공했습니다.");
    }

    @DeleteMapping
    public ResponseEntity<ApiResponseDto<String>> deleteParent(@AuthenticationPrincipal UserDetails userDetails){
        userService.deleteParent(Integer.parseInt(userDetails.getUsername()));
        return ApiResponseDto.success("회원이 탈퇴 되었습니다");
    }

    @PostMapping("/child")
    public ResponseEntity<ApiResponseDto<String>> signupChild(@RequestBody @Valid SignUpChildRequestDto signUpChildRequestDto, @AuthenticationPrincipal UserDetails userDetails){
        userService.saveChild(signUpChildRequestDto, Integer.parseInt(userDetails.getUsername()));
        return ApiResponseDto.created("자녀 등록에 성공했습니다.");
    }

    @PatchMapping("/child")
    public ResponseEntity<ApiResponseDto<String>> updateChild(@RequestBody @Valid UpdateChildRequestDto updateChildRequestDto, @AuthenticationPrincipal UserDetails userDetails){
        userService.updateChild(Integer.parseInt(userDetails.getUsername()), updateChildRequestDto);
        return ApiResponseDto.success("자녀 이름이 변경되었습니다");

    }

    @DeleteMapping ("/child")
    public ResponseEntity<ApiResponseDto<String>> deleteChild(@RequestParam("child_id") @NotNull Integer childId, @AuthenticationPrincipal UserDetails userDetails){
        userService.deleteChild(Integer.parseInt(userDetails.getUsername()), childId);
        return ApiResponseDto.success("자녀가 성공적으로 해제(탈퇴)되었습니다");
    }

    @GetMapping("/check")
    public ResponseEntity<ApiResponseDto<String>> checkLoginId(@RequestParam("login_id")
                                                                   @NotBlank
                                                                   @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9]{6,20}$", message = "로그인 ID는 영문과 숫자를 포함한 6~20자리 이어야 합니다.")
                                                                   String loginId){
        userService.checkLoginIdExists(loginId);
        return ApiResponseDto.success("사용 가능한 ID 입니다.");
    }

    @PostMapping("/password")
    public ResponseEntity<ApiResponseDto<String>> checkPassword(@RequestBody @Valid PasswordRequestDto passwordRequestDto, @AuthenticationPrincipal UserDetails userDetails){
        userService.checkPassword(passwordRequestDto.getPassword(), Integer.parseInt(userDetails.getUsername()));
        return ApiResponseDto.success("비밀 번호가 확인 되었습니다.");
    }

    @PatchMapping("/password")
    public ResponseEntity<ApiResponseDto<String>> updatePassword(@RequestBody @Valid PasswordRequestDto passwordRequestDto, @AuthenticationPrincipal UserDetails userDetails) {
        userService.updatePassword(passwordRequestDto.getPassword(), Integer.parseInt(userDetails.getUsername()));
        return ApiResponseDto.success("비밀 번호가 수정 되었습니다.");
    }
}
