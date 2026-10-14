@extends('layouts.admin.app')

@section('title', 'Add Game Book & Year')
@section('page_title', 'Add Game Book & Year')
@section('page_subtitle', $category->title)

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.game-book-years.store', $category) }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf

            <div class="cu-form-row cu-form-row--2">
                <div class="cu-field">
                    <label for="game_id">Game <span class="cu-required">*</span></label>
                    <select id="game_id" name="game_id">
                        <option value="">Select game</option>
                        @foreach ($games as $game)
                            <option value="{{ $game->id }}" @selected((string) old('game_id') === (string) $game->id)>
                                {{ $game->name }}
                            </option>
                        @endforeach
                    </select>
                    @error('game_id') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>

                <div class="cu-field">
                    <label for="year_id">Year <span class="cu-required">*</span></label>
                    <select id="year_id" name="year_id">
                        <option value="">Select year</option>
                        @foreach ($years as $year)
                            <option value="{{ $year->id }}" @selected((string) old('year_id') === (string) $year->id)>
                                {{ $year->title }}
                            </option>
                        @endforeach
                    </select>
                    @error('year_id') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>
            </div>

            <div class="cu-field">
                <label>Book</label>
                <div class="cu-book-pick-grid">
                    @forelse ($books as $book)
                        <label class="cu-book-pick">
                            <input
                                type="checkbox"
                                name="book_ids[]"
                                value="{{ $book->id }}"
                                @checked(in_array($book->id, $selectedBookIds, true))
                            >
                            <span class="cu-book-pick__card">
                                @if ($book->image_url)
                                    <img class="cu-book-pick__image" src="{{ $book->image_path }}" alt="{{ $book->title }}">
                                @else
                                    <span class="cu-book-pick__placeholder">
                                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                                    </span>
                                @endif
                                <span class="cu-book-pick__title">{{ $book->title }}</span>
                            </span>
                        </label>
                    @empty
                        <p class="cu-help">No active books available. Add books first.</p>
                    @endforelse
                </div>
                @error('book_ids') <p class="cu-field__error">{{ $message }}</p> @enderror
                @error('book_ids.*') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="image">Image <span class="cu-required">*</span></label>
                <label class="cu-image-area" for="image">
                    <img id="imagePreview" class="cu-image-area__preview" alt="Preview" hidden>
                    <span class="cu-image-area__placeholder" id="imagePlaceholder">
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload image</strong>
                        <small>PNG, JPG, or WEBP up to 4MB</small>
                    </span>
                    <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*">
                </label>
                @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
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
                <a href="{{ route('admin.game-book-years.index', $category) }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Save</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.game-book-years.partials.editor-assets')
