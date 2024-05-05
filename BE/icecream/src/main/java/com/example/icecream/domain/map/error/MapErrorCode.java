package com.example.icecream.domain.map.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum MapErrorCode {

    DESTINATION_NOT_FOUND("목적지를 찾을 수 없습니다."),
    GET_DESTINATION_ACCESS_DENIED("목적지 조회 권한이 없습니다."),
    REGISTER_DESTINATION_ACCESS_DENIED("목적지 등록 권한이 없습니다."),
    MODIFY_DESTINATION_ACCESS_DENIED("목적지 수정 권한이 없습니다."),
    DELETE_DESTINATION_ACCESS_DENIED("목적지 삭제 권한이 없습니다."),
    USER_NOT_FOUND("해당 사용자가 존재하지 않습니다.");

    private final String message;
}
