package com.example.icecream.domain.user.controller;

import com.example.icecream.common.dto.ApiResponseDto;
import com.example.icecream.domain.user.dto.SignUpChildRequestDto;
import com.example.icecream.domain.user.dto.SignUpParentRequestDto;
import com.example.icecream.domain.user.dto.UpdateChildRequestDto;
import com.example.icecream.domain.user.service.UserService;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;

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
    public ResponseEntity<ApiResponseDto<String>> signup(@RequestBody SignUpParentRequestDto signUpParentRequestDto){
        userService.saveParent(signUpParentRequestDto);
        return ApiResponseDto.created("회원 가입에 성공했습니다.");
    }

    @DeleteMapping
    public ResponseEntity<ApiResponseDto<String>> deleteParent(@AuthenticationPrincipal UserDetails userDetails){
        userService.deleteParent(Integer.parseInt(userDetails.getUsername()));
        return ApiResponseDto.success("회원이 탈퇴 되었습니다");
    }

    @PostMapping("/child")
    public ResponseEntity<ApiResponseDto<String>> signupChild(@RequestBody SignUpChildRequestDto signUpChildRequestDto){
        userService.saveChild(signUpChildRequestDto);
        return ApiResponseDto.created("자녀 등록에 성공했습니다.");
    }

    @PatchMapping("/child")
    public ResponseEntity<ApiResponseDto<String>> updateChild(@RequestBody UpdateChildRequestDto updateChildRequestDto, @AuthenticationPrincipal UserDetails userDetails){
        userService.updateChild(Integer.parseInt(userDetails.getUsername()), updateChildRequestDto);
        return ApiResponseDto.success("자녀 이름이 변경되었습니다");

    }

    @DeleteMapping ("/child")
    public ResponseEntity<ApiResponseDto<String>> deleteChild(@RequestParam @NotNull Integer childId, @AuthenticationPrincipal UserDetails userDetails){
        userService.deleteChild(Integer.parseInt(userDetails.getUsername()), childId);
        return ApiResponseDto.success("자녀가 성공적으로 해제(탈퇴)되었습니다");
    }

    @GetMapping("/check")
    public ResponseEntity<ApiResponseDto<String>> checkLoginId(@RequestParam @NotBlank String loginId){
        userService.checkLoginIdExists(loginId);
        return ApiResponseDto.success("사용 가능한 ID 입니다.");
    }


}



//    @GetMapping("/userInfo")
//    public ResponseEntity<?> getInfo(@AuthenticationPrincipal UserDetails userDetails){
//        User user = UserUtil.getUserFromUserDetails(userDetails);
//        return buildBasicResponse(HttpStatus.OK,user.getUserId());
//    }
//
//    @GetMapping("/check-nickname")
//    public ResponseEntity<?> checkNickname(@RequestParam("userNickname") String userNickname) {
//        userService.isValidateNickname(userNickname);
//        return buildBasicResponse(HttpStatus.OK,"해당 닉네임은 사용 가능합니다.");
//    }
//
//    @GetMapping("/check-loginId")
//    public ResponseEntity<?> checkLoginId(@RequestParam("userLoginId") String userLoginId) {
//        userService.isValidateLoginId(userLoginId);
//        return buildBasicResponse(HttpStatus.OK,"해당 아이디는 사용 가능합니다.");
//    }
//
//    @GetMapping("/update/check-nickname")
//    public ResponseEntity<?> updateCheckNickname(@RequestParam("userNickname") String userNickname) {
//        userService.isValidateNickname(userNickname);
//        return buildBasicResponse(HttpStatus.OK,"해당 닉네임은 사용 가능합니다.");
//    }
//
//    @GetMapping("/update/check-loginId")
//    public ResponseEntity<?> updateCheckLoginId(@RequestParam("userLoginId") String userLoginId) {
//        userService.isValidateLoginId(userLoginId);
//        return buildBasicResponse(HttpStatus.OK,"해당 아이디는 사용 가능합니다.");
//    }
//
//    @PatchMapping("/update/nickname")
//    public ResponseEntity<?> updateNickname(@RequestBody UpdateNicknameRequest userNickname, @AuthenticationPrincipal UserDetails userDetails) {
//        User user = UserUtil.getUserFromUserDetails(userDetails);
//        userService.updateNickname(userNickname.getUserNickname(),user.getUserId());
//        return buildBasicResponse(HttpStatus.OK,"닉네임 변경에 성공했습니다.");
//    }
//
//    @PatchMapping("/update/password")
//    public ResponseEntity<?> updatePassword(@RequestBody UpdatePasswordRequest userPassword, @AuthenticationPrincipal UserDetails userDetails) {
//        User user = UserUtil.getUserFromUserDetails(userDetails);
//        userService.updatePassword(userPassword,user.getUserId());
//        return buildBasicResponse(HttpStatus.OK,"비밀번호 변경에 성공했습니다.");
//    }
//}
