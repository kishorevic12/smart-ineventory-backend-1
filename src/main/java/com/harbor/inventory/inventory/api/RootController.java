package com.harbor.inventory.inventory.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class RootController {

    @GetMapping("/")
    public Map<String, String> root() {
        Map<String, String> body = new LinkedHashMap<>();
        body.put("status", "Inventory API running");
        return body;
    }
}
