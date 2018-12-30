package com.frontend.api.controller;

import com.frontend.api.dto.SentenceDto;
import com.frontend.api.dto.SentimentDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@CrossOrigin(origins = "*")
@RestController
public class SentimentController {

    @Value("${endpoints.microservice.url}")
    private String microserviceUrl;

    @PostMapping("/sentiment")
    public SentimentDto sentimentAnalysis(@RequestBody SentenceDto sentenceDto) {
        RestTemplate restTemplate = new RestTemplate();

        return restTemplate.postForEntity(microserviceUrl + "/analyse",
                sentenceDto, SentimentDto.class)
                .getBody();
    }

    @GetMapping("/testHealth")
    public void testHealth() {
    }
}


