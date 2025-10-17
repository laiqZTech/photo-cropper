<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Photo Cropper Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            margin: 24px;
        }
        .btn {
            display: inline-block;
            padding: 8px 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #1976d2;
            color: #fff;
            cursor: pointer;
            text-decoration: none;
        }
        .btn:hover {
            background: #1565c0;
        }
        .result {
            margin-top: 24px;
        }
        .result img {
            max-width: 360px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<h2>Welcome to Photo Cropper</h2>
<p>Click the button below to upload and crop an image.</p>

<!-- Upload link -->
<a href="#" id="openCropperPopup" class="btn">Upload &amp; Crop Image</a>

<!-- Result area -->
<div class="result">
    <p><strong>Cropped Result:</strong></p>
    <c:choose>
        <c:when test="${not empty photoName}">
            <!-- Show existing photo if present -->
            <img id="croppedImage" src="${pageContext.request.contextPath}/storage/${photoName}" alt="Employee Photo"
                 style="max-width: 360px; border: 1px solid #ccc; border-radius: 4px;">
        </c:when>
        <c:otherwise>
            <!-- Hidden until a new crop is returned -->
            <img id="croppedImage" alt="Cropped image will appear here" style="display:none;">
        </c:otherwise>
    </c:choose>
</div>

<!-- JavaScript -->
<script>
    // Get context path dynamically (e.g., /photo-cropper)
    var ctx = "${pageContext.request.contextPath}";
    var photoName = "${photoName != null ? photoName : ''}";

    // Function called by popup when cropping is done
    window.receiveCroppedImage = function(imageUrl) {
        var img = document.getElementById('croppedImage');
        img.src = imageUrl + "?t=" + new Date().getTime();
        img.style.display = 'inline-block';
    };

    // Open popup for cropping
    document.getElementById('openCropperPopup').addEventListener('click', function(e) {
        e.preventDefault();
        var popupUrl = ctx + "/crop" + (photoName ? "?photoName=" + encodeURIComponent(photoName) : "");
        window.open(
            popupUrl,
            'cropperPopup',
            'width=980,height=720,menubar=0,toolbar=0,location=0,status=0,scrollbars=1,resizable=1'
        );
    });
</script>

</body>
</html>