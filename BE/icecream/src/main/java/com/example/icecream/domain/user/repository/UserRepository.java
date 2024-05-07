package com.example.icecream.domain.user.repository;

import com.example.icecream.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer>{
    Optional<User> findByIdAndIsDeletedFalse(int id);
    Optional<User> findByLoginId(String loginId);
    Optional<User> findByDeviceId(String deviceId);
    boolean existsByLoginId(String loginId);
}
