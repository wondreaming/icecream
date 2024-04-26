package com.example.icecream.map.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.locationtech.jts.geom.Polygon;

@Entity
@Table(name = "crosswalk")
public class Crosswalk {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "crosswalk_area", nullable = false)
    @NotNull
    private Polygon crosswalkArea;

    @Column(name = "crosswalk_name", nullable = false, unique = true, length = 20)
    @NotNull
    private String crosswalkName;
}
