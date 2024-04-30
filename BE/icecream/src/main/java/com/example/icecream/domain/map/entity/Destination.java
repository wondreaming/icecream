package com.example.icecream.domain.map.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.IdGeneratorType;

import java.sql.Time;
import java.time.LocalTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Builder
@Table(name = "destination")
public class Destination {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id", nullable = false)
    @NotNull
    private int userId;

    @Column(name = "name", nullable = false, length = 20)
    @NotNull
    private String name;

    @Column(name = "icon", nullable = false)
    @NotNull
    private int icon;

    @Column(name = "latitude", nullable = false)
    @NotNull
    private double latitude;

    @Column(name = "longitude", nullable = false)
    @NotNull
    private double longitude;

    @Column(name = "start_time", nullable = false)
    @NotNull
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    @NotNull
    private LocalTime endTime;

    @Column(name = "day", nullable = false, length = 7)
    @NotNull
    private String day;

}
