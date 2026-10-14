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
          placeholder: 'Write game description...',
          toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link']],
            ['view', ['fullscreen', 'codeview']]
          ]
        });

        function bindPreview(inputId, previewId, placeholderId) {
          var input = document.getElementById(inputId);
          var preview = document.getElementById(previewId);
          var placeholder = document.getElementById(placeholderId);
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
        }

        bindPreview('sketch_image', 'sketchImagePreview', 'sketchImagePlaceholder');
        bindPreview('color_image', 'colorImagePreview', 'colorImagePlaceholder');

        var categorySelect = document.getElementById('game_category_id');
        var gameSelect = document.getElementById('game_id');
        var yearSelect = document.getElementById('year_id');
        var yearField = document.getElementById('yearField');
        var yearEmptyHelp = document.getElementById('yearEmptyHelp');
        var bookField = document.getElementById('bookField');
        var bookEmptyHelp = document.getElementById('bookEmptyHelp');
        var bookPickGrid = document.getElementById('bookPickGrid');
        var categoryLocked = categorySelect && categorySelect.disabled;
        var gameLocked = gameSelect && gameSelect.disabled;

        function selectedGameOption() {
          if (!gameSelect) return null;

          if (gameSelect.disabled) {
            return Array.prototype.find.call(gameSelect.options, function (option) {
              return option.selected && option.value;
            }) || null;
          }

          return gameSelect.options[gameSelect.selectedIndex] || null;
        }

        function filterBooks() {
          if (!bookField || !bookPickGrid) return;

          var gameOption = selectedGameOption();
          var gameId = gameOption && gameOption.value ? String(gameOption.value) : '';
          var yearId = yearSelect ? String(yearSelect.value || '') : '';
          var visibleCount = 0;

          bookField.hidden = !yearId;

          bookPickGrid.querySelectorAll('.cu-book-pick').forEach(function (pick) {
            var matches =
              yearId &&
              pick.getAttribute('data-game-id') === gameId &&
              pick.getAttribute('data-year-id') === yearId;
            var input = pick.querySelector('input[type="radio"]');

            pick.hidden = !matches;

            if (input) {
              input.disabled = !matches;
              if (!matches) {
                input.checked = false;
              }
            }

            if (matches) {
              visibleCount += 1;
            }
          });

          if (bookEmptyHelp) {
            bookEmptyHelp.hidden = !(yearId && visibleCount === 0);
          }
        }

        function filterYears() {
          if (!yearSelect || !yearField) return;

          var gameOption = selectedGameOption();
          var gameId = gameOption && gameOption.value ? String(gameOption.value) : '';
          var allowedYearIds = gameOption
            ? (gameOption.getAttribute('data-year-ids') || '').split(',').filter(Boolean)
            : [];
          var selectedValue = yearSelect.value;
          var visibleCount = 0;
          var stillVisible = false;

          yearField.hidden = !gameId;

          Array.prototype.forEach.call(yearSelect.options, function (option) {
            if (!option.value) {
              option.hidden = false;
              return;
            }

            var visible = allowedYearIds.indexOf(String(option.value)) !== -1;
            option.hidden = !visible;

            if (visible) {
              visibleCount += 1;
              if (option.value === selectedValue) {
                stillVisible = true;
              }
            }
          });

          if (!stillVisible) {
            yearSelect.value = '';
          }

          if (yearEmptyHelp) {
            yearEmptyHelp.hidden = !(gameId && visibleCount === 0);
          }

          filterBooks();
        }

        function filterGames() {
          if (!gameSelect || gameLocked) return;

          var categoryId = categorySelect ? String(categorySelect.value || '') : '';
          var selectedValue = gameSelect.value;
          var stillVisible = false;

          Array.prototype.forEach.call(gameSelect.options, function (option) {
            if (!option.value) {
              option.hidden = false;
              return;
            }

            var matchesCategory = !categoryId || option.getAttribute('data-category-id') === categoryId;
            option.hidden = !matchesCategory;

            if (matchesCategory && option.value === selectedValue) {
              stillVisible = true;
            }
          });

          if (!stillVisible) {
            gameSelect.value = '';
          }

          filterYears();
        }

        if (categorySelect && !categoryLocked) {
          categorySelect.addEventListener('change', filterGames);
        }

        if (gameSelect && !gameLocked) {
          gameSelect.addEventListener('change', filterYears);
        }

        if (yearSelect) {
          yearSelect.addEventListener('change', filterBooks);
        }

        filterGames();
        filterYears();
        filterBooks();

        var sketchesList = document.getElementById('sketchesList');
        var addSketchBtn = document.getElementById('addSketchBtn');
        var sketchIndex = sketchesList ? sketchesList.querySelectorAll('[data-sketch-row]').length : 0;

        function renumberSketches() {
          if (!sketchesList) return;
          sketchesList.querySelectorAll('[data-sketch-row]').forEach(function (row, index) {
            var title = row.querySelector('.cu-sketch-row__top strong');
            if (title) title.textContent = 'Sketch #' + (index + 1);
          });
        }

        function addSketchRow() {
          if (!sketchesList) return;

          var index = sketchIndex++;
          var row = document.createElement('div');
          row.className = 'cu-sketch-row';
          row.setAttribute('data-sketch-row', '');
          row.innerHTML =
            '<div class="cu-sketch-row__top">' +
              '<strong>Sketch #' + (index + 1) + '</strong>' +
              '<button type="button" class="cu-action-btn cu-action-btn--danger" data-remove-sketch title="Remove">' +
                '<i class="fa-regular fa-trash-can" aria-hidden="true"></i>' +
              '</button>' +
            '</div>' +
            '<div class="cu-form-row cu-form-row--2">' +
              '<div class="cu-field">' +
                '<label>Name <span class="cu-required">*</span></label>' +
                '<input type="text" name="sketches[' + index + '][name]" value="">' +
              '</div>' +
              '<div class="cu-field">' +
                '<label>Upload Sketch <span class="cu-required">*</span></label>' +
                '<input type="file" name="sketches[' + index + '][image]" accept="image/*" data-sketch-file>' +
              '</div>' +
            '</div>';

          sketchesList.appendChild(row);
          renumberSketches();
        }

        if (addSketchBtn) {
          addSketchBtn.addEventListener('click', function () {
            addSketchRow();
          });
        }

        if (sketchesList) {
          sketchesList.addEventListener('click', function (event) {
            var button = event.target.closest('[data-remove-sketch]');
            if (!button) return;
            var row = button.closest('[data-sketch-row]');
            if (row) row.remove();
            renumberSketches();
          });
        }
      })();
    </script>
@endpush
