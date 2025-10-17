package com.ztl.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class ImageStorageService {

    private final Path storageDir = Paths.get(System.getProperty("user.dir"), "storage");

    public ImageStorageService() throws IOException {
        if (!Files.exists(storageDir)) {
            Files.createDirectories(storageDir);
        }
    }

    /** Saves uploaded image to filesystem and returns the accessible relative URL path. */
    public String saveImage(MultipartFile file) throws IOException {
        String ext = "jpg";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.') + 1);
        }

        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
        String filename = "photo-" + timestamp + "-" + UUID.randomUUID() + "." + ext;

        Path target = storageDir.resolve(filename);
        Files.copy(file.getInputStream(), target);

        // Return a relative URL for later display, e.g. /photo-cropper/storage/photo-...
        return "/photo-cropper/storage/" + filename;
    }
}
