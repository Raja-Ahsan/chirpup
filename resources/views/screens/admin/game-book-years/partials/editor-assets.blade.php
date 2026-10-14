@push('styles')
    <link
        href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css"
        rel="stylesheet"
    >
@endpush

@push('scripts')
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script>
      (function () {
        $('#description').summernote({
          height: 240,
          placeholder: 'Write description...',
          toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link']],
            ['view', ['fullscreen', 'codeview']]
          ]
        });

        var input = document.getElementById('image');
        var preview = document.getElementById('imagePreview');
        var placeholder = document.getElementById('imagePlaceholder');
        if (!input || !preview) return;

        input.addEventListener('change', function () {
          var file = input.files && input.files[0];
          if (!file) return;

          var reader = new FileReader();
          reader.onload = function (event) {
            preview.src = event.target.result;
            preview.hidden = false;
            if (placeholder) placeholder.hidden = true;
          };
          reader.readAsDataURL(file);
        });
      })();
    </script>
@endpush
