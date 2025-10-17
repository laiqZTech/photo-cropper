package com.ztl.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class ImageStorageService {

    private final Path storageDir;

    public ImageStorageService() throws IOException {
        // Save images under the project's "storage" folder
        storageDir = Paths.get(System.getProperty("user.dir"), "storage");
        if (!Files.exists(storageDir)) {
            Files.createDirectories(storageDir);
        }
    }

    /**
     * Save or overwrite an image file, returning the relative URL.
     *
     * @param file     the file from the client
     * @param filename desired filename (existing or new)
     * @return the relative URL for the saved image
     */
    public String saveImage(MultipartFile file, String filename) throws IOException {
        Path target = storageDir.resolve(filename);
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        // Return the URL relative to the context path; adjust if your context changes
        return "/photo-cropper/storage/" + filename;
    }
}