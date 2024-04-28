package com.example.icecream.map.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.hibernate.annotations.Type;
import org.locationtech.jts.geom.Polygon;

@Entity
@Table(name = "road")
public class Road {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "road_area", nullable = false)
    @NotNull
    private Polygon roadArea;
}
