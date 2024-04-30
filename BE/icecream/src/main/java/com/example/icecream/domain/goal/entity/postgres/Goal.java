package com.example.icecream.domain.goal.entity.postgres;

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
@Table(name="goal")
public class Goal {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private int id;

        @Column(name = "user_id", nullable = false, unique = true)
        @NotNull
        private int userId;

        @Column(name = "period", nullable = false)
        @NotNull
        private int period;

        @Column(name = "record", nullable = false)
        @NotNull
        private int record;

        @Column(name = "content", nullable = false, length = 500)
        @NotNull
        private String content;

        @Column(name = "is_active", nullable = false)
        @NotNull
        private boolean isActive;

        @Column(name = "created_at", nullable = false)
        @CreatedDate
        @NotNull
        private LocalDateTime createdAt;

        @Column(name = "updated_at", nullable = false)
        @LastModifiedDate
        @NotNull
        private LocalDateTime updatedAt;
}
