package com.example.userserver.user.entity;

import com.example.common.entity.BaseEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
@Entity
@Table(name="users")
public class User extends BaseEntity {

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
    private Boolean isParent;

    @Column(name = "profile_image", columnDefinition = "TEXT")
    private String profileImage;


    @Column(name = "is_deleted", nullable = false)
    @NotNull
    private Boolean isDeleted = false;

    public void updateUsername(String newUsername) {
        this.username = newUsername;
    }
    public void updatePassword(String newPassword) { this.password = newPassword; }
    public void updateProfileImage(String newProfileImage) {this.profileImage = newProfileImage;}
    public void updatePhoneNumber(String newPhoneNumber) {this.phoneNumber = newPhoneNumber;}
    public void updateDeviceId(String newDeviceId) {this.deviceId = newDeviceId;}
    public void deleteUser() {
        this.isDeleted = true;
    }

}
