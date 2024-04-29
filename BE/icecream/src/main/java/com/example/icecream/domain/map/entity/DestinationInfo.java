package com.example.icecream.domain.map.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.locationtech.jts.geom.Point;

@Entity
@Table(name = "destination")
public class DestinationInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "destination_id", nullable = false, unique = true)
    @NotNull
    private int destinationId;

    @Column(name = "location", nullable = false, columnDefinition = "geometry(Point, 4326)")
    @NotNull
    private Point location;

    @Column(name = "radius", nullable = false)
    @NotNull
    private int radius;
}
