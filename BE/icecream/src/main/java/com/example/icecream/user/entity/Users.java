package com.example.icecream.user.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
@Entity
@Table(name="users")
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "username", nullable = false, length = 10)
    @NotNull
    private String username;

    @Column(name = "phone_number", nullable = false, length = 20, unique = true)
    @NotNull
    private String phoneNumber;

    @Column(name = "login_id", length = 20, unique = true)
    private String loginId;

    @Column(name = "password", length = 100)
    private String password;

    @Column(name = "device_id", nullable = false, length = 20, unique = true)
    @NotNull
    private String deviceId;

    @Column(name = "is_parent", nullable = false)
    @NotNull
    private boolean isParent;

    @Column(name = "profile_image", columnDefinition = "TEXT")
    private String profileImage;

    @Column(name = "created_at", nullable = false)
    @CreatedDate
    @NotNull
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @LastModifiedDate
    @NotNull
    private LocalDateTime updatedAt;

    @Column(name = "is_deleted", nullable = false)
    @NotNull
    private boolean isDeleted = false;
}
