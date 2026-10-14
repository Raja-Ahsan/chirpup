@extends('layouts.admin.app')

@section('title', 'Edit Game')
@section('page_title', 'Edit Game')
@section('page_subtitle', 'Update game details')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.games.update', $game) }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf
            @method('PUT')

            <div class="cu-field">
                <label for="name">Name <span class="cu-required">*</span></label>
                <input id="name" type="text" name="name" value="{{ old('name', $game->name) }}">
                @error('name') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <input type="hidden" name="game_category_id" value="{{ old('game_category_id', $selectedCategoryId) }}">
            @error('game_category_id') <p class="cu-field__error">{{ $message }}</p> @enderror

            <div class="cu-field">
                <label for="image">Image</label>
                <label class="cu-image-area" for="image">
                    <img
                        id="imagePreview"
                        class="cu-image-area__preview"
                        src="{{ $game->image_path }}"
                        alt="{{ $game->name }}"
                        @if (! $game->image_url) hidden @endif
                    >
                    <span class="cu-image-area__placeholder" id="imagePlaceholder" @if ($game->image_url) hidden @endif>
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload game image</strong>
                        <small>PNG, JPG, or WEBP up to 4MB</small>
                    </span>
                    <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*">
                </label>
                <p class="cu-help">Leave empty to keep the current image.</p>
                @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="cu-editor">{{ old('description', $game->description) }}</textarea>
                @error('description') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="status">Status <span class="cu-required">*</span></label>
                <select id="status" name="status">
                    <option value="active" @selected(old('status', $game->status) === 'active')>Active</option>
                    <option value="inactive" @selected(old('status', $game->status) === 'inactive')>Inactive</option>
                </select>
                @error('status') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form__actions">
                <a href="{{ route('admin.games.category-games', $game->gameCategory) }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Update Game</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.games.partials.editor-assets')
