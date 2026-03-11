package com.harbor.inventory.inventory.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class RootController {

    @GetMapping("/")
    public Map<String, Object> root() {
        return Map.of(
                "service", "harbor-inventory",
                "status", "ok",
                "health", "/actuator/health",
                "api", "/api"
        );
    }
}
