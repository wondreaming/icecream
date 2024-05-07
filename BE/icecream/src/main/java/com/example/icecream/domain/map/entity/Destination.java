package com.example.icecream.domain.map.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
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
    private Integer id;

    @Column(name = "user_id", nullable = false)
    @NotNull
    private Integer userId;

    @Column(name = "name", nullable = false, length = 20)
    @NotNull
    private String name;

    @Column(name = "icon", nullable = false)
    @NotNull
    private Integer icon;

    @Column(name = "latitude", nullable = false)
    @NotNull
    private Double latitude;

    @Column(name = "longitude", nullable = false)
    @NotNull
    private Double longitude;

    @Column(name = "start_time", nullable = false)
    @NotNull
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    @NotNull
    private LocalTime endTime;

    @Column(name = "day", nullable = false, length = 7)
    @NotNull
    private String day;

    @Column(name = "location", nullable = false, columnDefinition = "geography(Point, 4326)")
    @NotNull
    private Point location;

    @Column(name = "radius", nullable = false)
    @NotNull
    private Double radius = 100.0;

    @Column(name = "created_at", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public void updateDestination(String name, Integer icon, Double latitude, Double longitude,
                                  LocalTime startTime, LocalTime endTime, String day, Point location) {
        this.name = name;
        this.icon = icon;
        this.latitude = latitude;
        this.longitude = longitude;
        this.startTime = startTime;
        this.endTime = endTime;
        this.day = day;
        this.location = location;
    }
}
