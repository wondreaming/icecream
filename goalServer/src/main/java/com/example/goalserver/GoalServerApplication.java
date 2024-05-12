package com.example.goalserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class GoalServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(GoalServerApplication.class, args);
	}

}
