@extends('layouts.admin.app')

@section('title', 'Add Game')
@section('page_title', 'Add Game')
@section('page_subtitle', 'Create a new game')

@php
    $selectedCategoryId = old(
        'game_category_id',
        $selectedCategoryId ?? $selectedGame?->game_category_id
    );
    $lockCategory = filled($selectedCategoryId);
    $lockGame = filled($selectedGameId);
    $selectedGameValue = old('game_id', $selectedGameId);
    $selectedYearValue = old('year_id');
    $selectedBookId = old('book_id');
@endphp

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.game-types.store') }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf

            <div class="cu-field">
                <label for="name">Name <span class="cu-required">*</span></label>
                <input id="name" type="text" name="name" value="{{ old('name') }}">
                @error('name') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="game_category_id">Game Category <span class="cu-required">*</span></label>
                @if ($lockCategory)
                    <input type="hidden" name="game_category_id" value="{{ $selectedCategoryId }}">
                    <select id="game_category_id" disabled>
                        <option value="">Select game category</option>
                        @foreach ($categories as $category)
                            <option value="{{ $category->id }}" @selected((string) $selectedCategoryId === (string) $category->id)>
                                {{ $category->title }}
                            </option>
                        @endforeach
                    </select>
                @else
                    <select id="game_category_id" name="game_category_id">
                        <option value="">Select game category</option>
                        @foreach ($categories as $category)
                            <option value="{{ $category->id }}" @selected((string) old('game_category_id') === (string) $category->id)>
                                {{ $category->title }}
                            </option>
                        @endforeach
                    </select>
                @endif
                @error('game_category_id') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="game_id">Game <span class="cu-required">*</span></label>
                @if ($lockGame)
                    <input type="hidden" name="game_id" value="{{ old('game_id', $selectedGameId) }}">
                    <select id="game_id" disabled>
                        <option value="">Select game</option>
                        @foreach ($games as $game)
                            <option
                                value="{{ $game->id }}"
                                data-category-id="{{ $game->game_category_id }}"
                                data-year-ids="{{ collect($game->book_year_ids ?? [])->join(',') }}"
                                @selected((string) old('game_id', $selectedGameId) === (string) $game->id)
                            >
                                {{ $game->name }}
                            </option>
                        @endforeach
                    </select>
                @else
                    <select id="game_id" name="game_id">
                        <option value="">Select game</option>
                        @foreach ($games as $game)
                            <option
                                value="{{ $game->id }}"
                                data-category-id="{{ $game->game_category_id }}"
                                data-year-ids="{{ collect($game->book_year_ids ?? [])->join(',') }}"
                                @selected((string) old('game_id') === (string) $game->id)
                            >
                                {{ $game->name }}
                            </option>
                        @endforeach
                    </select>
                @endif
                @error('game_id') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field" id="yearField" @if (! filled($selectedGameValue)) hidden @endif>
                <label for="year_id">Year <span class="cu-required">*</span></label>
                <select id="year_id" name="year_id">
                    <option value="">Select year</option>
                    @foreach ($years as $year)
                        <option value="{{ $year->id }}" @selected((string) $selectedYearValue === (string) $year->id)>
                            {{ $year->title }}
                        </option>
                    @endforeach
                </select>
                <p class="cu-help" id="yearEmptyHelp" hidden>No years found for this game. Add Game Book & Year first.</p>
                @error('year_id') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field" id="bookField" @if (! filled($selectedYearValue)) hidden @endif>
                <label>Book</label>
                <div class="cu-book-pick-grid" id="bookPickGrid">
                    @forelse ($gameBooks as $gameBook)
                        @continue(! $gameBook->book)
                        <label
                            class="cu-book-pick"
                            data-game-id="{{ $gameBook->game_id }}"
                            data-year-id="{{ $gameBook->year_id }}"
                            hidden
                        >
                            <input
                                type="radio"
                                name="book_id"
                                value="{{ $gameBook->book_id }}"
                                @checked((string) $selectedBookId === (string) $gameBook->book_id)
                                disabled
                            >
                            <span class="cu-book-pick__card">
                                @if ($gameBook->book->image_url)
                                    <img class="cu-book-pick__image" src="{{ $gameBook->book->image_path }}" alt="{{ $gameBook->book->title }}">
                                @else
                                    <span class="cu-book-pick__placeholder">
                                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                                    </span>
                                @endif
                                <span class="cu-book-pick__title">{{ $gameBook->book->title }}</span>
                            </span>
                        </label>
                    @empty
                        <p class="cu-help">No books linked yet.</p>
                    @endforelse
                </div>
                <p class="cu-help" id="bookEmptyHelp" hidden>No books found for this year. Add books in Game Book & Year.</p>
                @error('book_id') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="points">Points <span class="cu-required">*</span></label>
                <input id="points" type="number" name="points" min="0" value="{{ old('points', 0) }}">
                @error('points') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form-row cu-form-row--2">
                <div class="cu-field">
                    <label for="sketch_image">Sketch Image <span class="cu-required">*</span></label>
                    <label class="cu-image-area" for="sketch_image">
                        <img id="sketchImagePreview" class="cu-image-area__preview" alt="Sketch preview" hidden>
                        <span class="cu-image-area__placeholder" id="sketchImagePlaceholder">
                            <i class="fa-regular fa-image" aria-hidden="true"></i>
                            <strong>Click to upload sketch image</strong>
                            <small>PNG, JPG, or WEBP up to 4MB</small>
                        </span>
                        <input id="sketch_image" class="cu-image-area__input" type="file" name="sketch_image" accept="image/*">
                    </label>
                    @error('sketch_image') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>

                <div class="cu-field">
                    <label for="color_image">Color Image</label>
                    <label class="cu-image-area" for="color_image">
                        <img id="colorImagePreview" class="cu-image-area__preview" alt="Color preview" hidden>
                        <span class="cu-image-area__placeholder" id="colorImagePlaceholder">
                            <i class="fa-regular fa-image" aria-hidden="true"></i>
                            <strong>Click to upload color image</strong>
                            <small>PNG, JPG, or WEBP up to 4MB</small>
                        </span>
                        <input id="color_image" class="cu-image-area__input" type="file" name="color_image" accept="image/*">
                    </label>
                    @error('color_image') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>
            </div>

            <div class="cu-sketches">
                <div class="cu-sketches__head">
                    <div>
                        <h3 class="cu-sketches__title">Sketches</h3>
                        <p class="cu-help">Add extra sketch items for this game.</p>
                    </div>
                    <button type="button" class="cu-btn" id="addSketchBtn">Add Sketches</button>
                </div>
                <div id="sketchesList" class="cu-sketches__list">
                    @foreach (old('sketches', []) as $index => $sketch)
                        <div class="cu-sketch-row" data-sketch-row>
                            <div class="cu-sketch-row__top">
                                <strong>Sketch #{{ $index + 1 }}</strong>
                                <button type="button" class="cu-action-btn cu-action-btn--danger" data-remove-sketch title="Remove">
                                    <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                </button>
                            </div>
                            <div class="cu-form-row cu-form-row--2">
                                <div class="cu-field">
                                    <label>Name <span class="cu-required">*</span></label>
                                    <input type="text" name="sketches[{{ $index }}][name]" value="{{ $sketch['name'] ?? '' }}">
                                    @error("sketches.$index.name") <p class="cu-field__error">{{ $message }}</p> @enderror
                                </div>
                                <div class="cu-field">
                                    <label>Upload Sketch <span class="cu-required">*</span></label>
                                    <input type="file" name="sketches[{{ $index }}][image]" accept="image/*" data-sketch-file>
                                    @error("sketches.$index.image") <p class="cu-field__error">{{ $message }}</p> @enderror
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
                @error('sketches') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="cu-editor">{{ old('description') }}</textarea>
                @error('description') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="status">Status <span class="cu-required">*</span></label>
                <select id="status" name="status">
                    <option value="active" @selected(old('status', 'active') === 'active')>Active</option>
                    <option value="inactive" @selected(old('status') === 'inactive')>Inactive</option>
                </select>
                @error('status') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form__actions">
                @if (! empty($selectedGame))
                    <a href="{{ route('admin.game-types.by-game', $selectedGame) }}" class="cu-btn cu-btn--ghost">Cancel</a>
                @elseif (! empty($selectedCategory))
                    <a href="{{ route('admin.sketches.index', $selectedCategory) }}" class="cu-btn cu-btn--ghost">Cancel</a>
                @else
                    <a href="{{ route('admin.game-types.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                @endif
                <button type="submit" class="cu-btn">Save Game</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.game-types.partials.editor-assets')
