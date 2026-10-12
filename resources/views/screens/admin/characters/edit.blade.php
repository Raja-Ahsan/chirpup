@extends('layouts.admin.app')

@section('title', 'Edit Character')
@section('page_title', 'Edit Character')
@section('page_subtitle', 'Update character details')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.characters.update', $character) }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf
            @method('PUT')

            <div class="cu-field">
                <label for="name">Name <span class="cu-required">*</span></label>
                <input id="name" type="text" name="name" value="{{ old('name', $character->name) }}">
                @error('name') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="image">Image</label>
                <label class="cu-image-area" for="image">
                    <img
                        id="imagePreview"
                        class="cu-image-area__preview"
                        src="{{ $character->image_path }}"
                        alt="{{ $character->name }}"
                        @if (! $character->image_url) hidden @endif
                    >
                    <span class="cu-image-area__placeholder" id="imagePlaceholder" @if ($character->image_url) hidden @endif>
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload character image</strong>
                        <small>PNG, JPG, or WEBP up to 4MB</small>
                    </span>
                    <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*">
                </label>
                <p class="cu-help">Leave empty to keep the current image.</p>
                @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="cu-editor">{{ old('description', $character->description) }}</textarea>
                @error('description') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="status">Status <span class="cu-required">*</span></label>
                <select id="status" name="status">
                    <option value="active" @selected(old('status', $character->status) === 'active')>Active</option>
                    <option value="inactive" @selected(old('status', $character->status) === 'inactive')>Inactive</option>
                </select>
                @error('status') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form__actions">
                <a href="{{ route('admin.characters.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Update Character</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.characters.partials.editor-assets')
