package com.ztl.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("app", "photo-cropper");
        model.addAttribute("message", "Spring MVC + JSP is up.");
        return "home"; // -> /WEB-INF/jsp/home.jsp
    }

    @GetMapping("/crop")
    public String cropPage() { return "crop"; }
}
