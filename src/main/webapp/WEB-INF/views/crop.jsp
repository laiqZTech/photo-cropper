<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload and Crop ID Photo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- jQuery & Cropper.js -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.css">
    <script src="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.js"></script>

    <!-- Responsive Enterprise Styling -->
    <style>
        body {
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            margin: 0;
            background-color: #f7f9fb;
            color: #333;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }

        header {
            background-color: #004080;
            color: #fff;
            padding: 14px 24px;
            flex-shrink: 0;
        }

        header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 500;
        }

        main {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 12px;
            padding: 12px;
            box-sizing: border-box;
            overflow-y: auto;
            min-height: 0;
        }

        /* --- Top: guideline row --- */
        .guideline-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: #fff;
            border: 1px solid #dce3eb;
            border-radius: 6px;
            padding: 12px;
            gap: 20px;
            flex-wrap: wrap;
        }

        .guideline-text {
            flex: 1 1 250px;
            font-size: 14px;
            line-height: 1.5;
        }

        .guideline-text h3 {
            color: #004080;
            font-size: 16px;
            margin-top: 0;
        }

        .guideline-img {
            flex: 1 1 250px;
            text-align: center;
        }

        .guideline-img img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        /* --- Bottom: crop + preview --- */
        .bottom-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            flex: 1;
            min-height: 0;
        }

        .workspace, .preview-container {
            background: #fff;
            border: 1px solid #dce3eb;
            border-radius: 6px;
            padding: 10px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        .upload-area {
            flex-shrink: 0;
            margin-bottom: 8px;
        }

        .upload-area input[type=file] {
            width: 100%;
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #fafafa;
        }

        .crop-area {
            flex: 1;
            border: 1px dashed #bbb;
            background: #f9fafb;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            min-height: 0;
        }

        .crop-area img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .preview-container {
            align-items: center;
            justify-content: flex-start;
        }

        .preview-container canvas {
            border: 1px solid #ccc;
            border-radius: 4px;
            display: block;
            max-width: 100%;
            height: auto;
            aspect-ratio: 35 / 45; /* Maintain UK passport ratio */
        }

        footer {
            flex-shrink: 0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 14px 24px;
            border-top: 1px solid #ddd;
            background: #fff;
            position: sticky;
            bottom: 0;
            z-index: 10;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            border: 1px solid transparent;
            font-size: 14px;
        }

        .btn.primary {
            background-color: #004080;
            color: #fff;
        }

        .btn.primary:hover {
            background-color: #0055b3;
        }

        .btn.secondary {
            background-color: #e4e6eb;
            color: #333;
        }

        .btn.secondary:hover {
            background-color: #d8dadf;
        }

        @media (max-width: 900px) {
            .bottom-row {
                grid-template-columns: 1fr;
            }
            .preview-container {
                max-height: 350px;
            }
        }
    </style>
</head>

<body>
<header>
    <h2>Upload and Crop Photo – ID Card Guidelines</h2>
</header>

<main>
    <!-- Top: Guidelines -->
    <div class="guideline-row">
        <div class="guideline-text">
            <h3>UK Passport-style Photo Guidelines</h3>
            <ul>
                <li>Use a plain, light-coloured background (cream or grey).</li>
                <li>Face the camera directly with a neutral expression.</li>
                <li>Keep eyes open and mouth closed.</li>
                <li>No headwear or glasses with glare.</li>
                <li>Ensure full head and shoulders visible – no shadows.</li>
            </ul>
        </div>
        <div class="guideline-img">
            <img src="https://www.researchgate.net/profile/Michael-Jones-75/publication/304123676/figure/fig4/AS:614161753874437@1523459482472/Example-of-UK-passport-photo-requirements-From-UK-Government-2013-19.png"
                 alt="UK Passport Photo Example">
        </div>
    </div>

    <!-- Bottom: Crop & Preview -->
    <div class="bottom-row">
        <!-- Left: Upload + Crop -->
        <section class="workspace">
            <div class="upload-area">
                <input type="file" id="file" accept="image/*">
            </div>
            <div class="crop-area">
                <img id="img" alt="Selected">
                <div id="placeholder">Choose a photo to start cropping…</div>
            </div>
        </section>

        <!-- Right: Preview -->
        <section class="preview-container">
            <p><strong>Preview (700 × 900)</strong></p>
            <canvas id="preview" width="350" height="450"></canvas>
        </section>
    </div>
</main>

<footer>
    <button id="useBtn" class="btn primary" disabled>Use This Photo</button>
    <button id="cancelBtn" class="btn secondary" onclick="window.close()">Cancel</button>
</footer>

<!-- Cropper logic -->
<script>
    (function(){
        var cropper = null;
        var $img = $('#img');
        var $file = $('#file');
        var $use = $('#useBtn');
        var $placeholder = $('#placeholder');
        var preview = document.getElementById('preview');

        function initCropper(){
            if (cropper) { try { cropper.destroy(); } catch(e){} }
            cropper = new Cropper($img[0], {
                aspectRatio: 35 / 45,
                viewMode: 1,
                responsive: true,
                autoCropArea: 1,
                movable: true,
                zoomable: true,
                scalable: true,
                background: false,
                ready: function() {
                    $use.prop('disabled', false);
                    drawPreview();
                },
                crop: drawPreview
            });
        }

        function drawPreview(){
            if (!cropper) return;
            var canvas = cropper.getCroppedCanvas({ width: 700, height: 900 });
            if (!canvas) return;

            const ratio = 35 / 45;
            const container = document.querySelector('.preview-container');
            const maxWidth = container.clientWidth - 20;
            const maxHeight = container.clientHeight - 50;

            let previewWidth = maxWidth;
            let previewHeight = previewWidth / ratio;
            if (previewHeight > maxHeight) {
                previewHeight = maxHeight;
                previewWidth = previewHeight * ratio;
            }

            preview.width = previewWidth;
            preview.height = previewHeight;

            const ctx = preview.getContext('2d');
            ctx.clearRect(0, 0, preview.width, preview.height);
            ctx.drawImage(canvas, 0, 0, preview.width, preview.height);
        }

        function getUrl(file){
            return (window.URL || window.webkitURL).createObjectURL(file);
        }

        $file.on('change', function(){
            var f = this.files && this.files[0];
            if (!f) return;
            if (!/^image\/(jpeg|jpg|png)$/i.test(f.type)) {
                alert('Please select a JPEG or PNG image.');
                this.value = '';
                return;
            }
            $img.attr('src', getUrl(f)).one('load', function() {
                $placeholder.hide();
                initCropper();
            });
        });

        // Redraw cropper and preview on window resize
        $(window).on('resize', function() {
            if (cropper) {
                cropper.reset();
                cropper.render();
                drawPreview();
            }
        });

        // Save cropped image
        $use.on('click', function(e){
            e.preventDefault();
            if (!cropper) return;

            var canvas = cropper.getCroppedCanvas({ width: 700, height: 900 });
            if (!canvas) { alert('Could not crop.'); return; }

            canvas.toBlob(function(blob) {
                var formData = new FormData();
                formData.append("file", blob, "cropped.jpg");

                $.ajax({
                    url: "${pageContext.request.contextPath}/uploadCropped",
                    method: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(responseUrl) {
                        if (window.opener && typeof window.opener.receiveCroppedImage === 'function') {
                            window.opener.receiveCroppedImage(responseUrl);
                        }
                        window.close();
                    },
                    error: function(xhr) {
                        alert("Upload failed: " + (xhr.responseText || xhr.statusText));
                    }
                });
            }, 'image/jpeg', 0.92);
        });
    })();
</script>
</body>
</html>