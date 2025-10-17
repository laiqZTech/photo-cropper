package com.ztl.controller;

import com.ztl.service.ImageStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class HomeController {

    @Autowired
    private ImageStorageService imageStorageService;

    @PostMapping("/uploadCropped")
    @ResponseBody
    public ResponseEntity<?> uploadCropped(@RequestParam("file") MultipartFile file) {
        try {
            String savedUrl = imageStorageService.saveImage(file);
            return ResponseEntity.ok(savedUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("app", "photo-cropper");
        model.addAttribute("message", "Spring MVC + JSP is up.");
        return "home"; // -> /WEB-INF/jsp/home.jsp
    }

    @GetMapping("/crop")
    public String cropPage() {
        return "crop";
    }
}