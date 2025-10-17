<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Crop Image</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.js"></script>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; margin: 16px; }
    .container { display: grid; grid-template-columns: 320px 1fr; gap: 16px; }
    .box { border:1px solid #ddd; border-radius:6px; padding:12px; }
    .crop { min-height:420px; display:flex; align-items:center; justify-content:center;
      background:#fafafa; border:1px dashed #bbb; }
    .crop img { max-width:100%; }
    .btn { padding:8px 14px; border:1px solid #ccc; background:#f7f7f7;
      border-radius:4px; cursor:pointer; }
    .btn.primary { background:#1976d2; color:#fff; border-color:#1976d2; }
    .btn:disabled { opacity:.6; cursor:not-allowed; }
    .actions { margin-top:12px; display:flex; gap:8px; }
  </style>
</head>
<body>
<h3>Upload & Crop Photo</h3>

<div class="container">
  <div class="box">
    <p><strong>Preview (700×900)</strong></p>
    <canvas id="preview" style="max-width:100%;"></canvas>
    <div class="actions">
      <button id="useBtn" class="btn primary" disabled>Use This Photo</button>
      <button id="closeBtn" class="btn" onclick="window.close()">Cancel</button>
    </div>
  </div>

  <div class="box">
    <input type="file" id="file" accept="image/*">
    <div class="crop" style="margin-top:8px;">
      <img id="img" alt="Selected" style="display:none;">
      <div id="ph">Choose a photo…</div>
    </div>
  </div>
</div>

<script>
  (function(){
    var cropper = null;
    var $img = $('#img');
    var $ph = $('#ph');
    var $file = $('#file');
    var $use = $('#useBtn');
    var preview = document.getElementById('preview');

    function initCropper(){
      if (cropper) { try { cropper.destroy(); } catch(e){} }
      cropper = new Cropper($img[0], {
        aspectRatio: 35/45,
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        zoomable: true,
        background: false,
        ready: function(){ $use.prop('disabled', false); drawPreview(); },
        crop: drawPreview
      });
    }

    function drawPreview(){
      if (!cropper) return;
      var c = cropper.getCroppedCanvas({ width: 700, height: 900 });
      if (!c) return;
      preview.width = c.width;
      preview.height = c.height;
      preview.getContext('2d').drawImage(c, 0, 0);
    }

    function urlOf(file){
      return (window.URL || window.webkitURL).createObjectURL(file);
    }

    $file.on('change', function(){
      var f = this.files && this.files[0];
      if (!f) return;
      if (!/^image\/(jpeg|jpg|png)$/i.test(f.type)) {
        alert('Please choose a JPEG or PNG image.');
        this.value = '';
        return;
      }
      $ph.hide();
      $img.show().attr('src', urlOf(f)).one('load', initCropper);
    });

    $use.on('click', function(e){
      e.preventDefault();
      if (!cropper) return;
      var c = cropper.getCroppedCanvas({ width: 700, height: 900 });
      if (!c) { alert('Could not crop.'); return; }
      var dataUrl = c.toDataURL('image/jpeg', 0.92);
      // Send the cropped image back to home.jsp
      if (window.opener && typeof window.opener.receiveCroppedImage === 'function') {
        window.opener.receiveCroppedImage(dataUrl);
      }
      window.close();
    });
  })();
</script>
</body>
</html>