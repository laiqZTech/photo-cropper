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
    public ResponseEntity<?> uploadCropped(@RequestParam("file") MultipartFile file,
                                           @RequestParam(value = "name", required = false) String name) {
        try {
            // If a name is supplied, we overwrite the existing file; otherwise we use the original filename
            String savedUrl = imageStorageService.saveImage(
                    file,
                    (name != null && !name.isEmpty()) ? name : file.getOriginalFilename()
            );
            return ResponseEntity.ok(savedUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/")
    public String home(Model model,
                       @RequestParam(value = "photoName", required = false) String photoName) {
        // Expose the existing photoName to the JSP, if present
        model.addAttribute("photoName", photoName);
        return "home"; // maps to /WEB-INF/jsp/home.jsp
    }

    @GetMapping("/crop")
    public String cropPage() {
        return "crop"; // maps to /WEB-INF/jsp/crop.jsp
    }
}