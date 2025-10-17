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

  <!-- Simple, modern enterprise styling -->
  <style>
    body {
      font-family: "Segoe UI", Roboto, Arial, sans-serif;
      margin: 0;
      background-color: #f7f9fb;
      color: #333;
      height: 100vh;
      display: flex;
      flex-direction: column;
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
      display: grid;
      grid-template-columns: 360px 1fr;
      gap: 16px;
      padding: 16px;
      box-sizing: border-box;
      overflow: hidden;
    }

    .left-panel {
      display: grid;
      grid-template-rows: auto 1fr;
      gap: 12px;
      overflow: hidden;
    }

    section.guide, section.preview-container, section.workspace {
      background: #fff;
      border: 1px solid #dce3eb;
      border-radius: 6px;
      padding: 12px;
      box-sizing: border-box;
      overflow: hidden;
    }

    section.guide ul {
      font-size: 14px;
      padding-left: 20px;
      line-height: 1.4;
    }

    section.guide img {
      display: block;
      margin: 8px auto;
      max-width: 100%;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    .preview-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    .preview-container canvas {
      border: 1px solid #ccc;
      border-radius: 4px;
      width: 100%;
      height: auto;
      max-height: 400px;
      box-sizing: border-box;
    }

    .workspace {
      display: flex;
      flex-direction: column;
      gap: 8px;
      overflow: hidden;
    }

    .upload-area {
      flex-shrink: 0;
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
    }

    .crop-area img {
      max-width: 100%;
      max-height: 100%;
      object-fit: contain;
    }

    footer {
      flex-shrink: 0;
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      padding: 14px 24px;
      border-top: 1px solid #ddd;
      background: #fff;
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
  </style>
</head>
<body>

<header>
  <h2>Upload and Crop Photo – ID Card Guidelines</h2>
</header>

<main>
  <div class="left-panel">
    <section class="guide">
      <h3>UK Passport-style Photo Guidelines</h3>
      <ul>
        <li>Use a plain, light-coloured background (cream or grey).</li>
        <li>Face the camera directly with a neutral expression.</li>
        <li>Keep eyes open and mouth closed.</li>
        <li>No headwear or glasses with glare.</li>
        <li>Ensure full head and shoulders visible – no shadows.</li>
      </ul>
      <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/UK_passport_photo_guidelines.png/320px-UK_passport_photo_guidelines.png"
           alt="UK Passport Photo Example">
      <p style="font-size:13px; color:#555; text-align:center;">
        Example of compliant photo (for reference only)
      </p>
    </section>

    <section class="preview-container">
      <p><strong>Preview (700 × 900)</strong></p>
      <canvas id="preview" width="350" height="450"></canvas>
    </section>
  </div>

  <section class="workspace">
    <div class="upload-area">
      <input type="file" id="file" accept="image/*">
    </div>
    <div class="crop-area">
      <img id="img" alt="Selected">
      <div id="placeholder">Choose a photo to start cropping…</div>
    </div>
  </section>
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
        restore: true,
        checkOrientation: true,
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

      // Ensure cropper and preview resize with window
      $(window).on('resize', function() {
        if (cropper) {
          cropper.reset();
          cropper.render();
          drawPreview();
        }
      });
    }

    function drawPreview(){
      if (!cropper) return;
      var canvas = cropper.getCroppedCanvas({ width: 700, height: 900 });
      if (!canvas) return;

      var previewWidth = document.querySelector('.preview-container').clientWidth - 20;
      var scale = previewWidth / 700;
      var previewHeight = 900 * scale;

      preview.width = previewWidth;
      preview.height = previewHeight;

      var ctx = preview.getContext('2d');
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