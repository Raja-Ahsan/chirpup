@extends('layouts.admin.app')

@section('title', 'Add Character')
@section('page_title', 'Add Character')
@section('page_subtitle', 'Create a new ChirpUp character')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.characters.store') }}" enctype="multipart/form-data" class="cu-form">
            @csrf

            <div class="cu-field">
                <label for="name">Name</label>
                <input id="name" type="text" name="name" value="{{ old('name') }}" required>
                @error('name') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="image">Image</label>
                <label class="cu-image-area" for="image">
                    <img id="imagePreview" class="cu-image-area__preview" alt="Character preview" hidden>
                    <span class="cu-image-area__placeholder" id="imagePlaceholder">
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload character image</strong>
                        <small>PNG, JPG, or WEBP up to 4MB</small>
                    </span>
                    <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*" required>
                </label>
                @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="cu-editor">{{ old('description') }}</textarea>
                @error('description') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="status">Status</label>
                <select id="status" name="status" required>
                    <option value="active" @selected(old('status', 'active') === 'active')>Active</option>
                    <option value="inactive" @selected(old('status') === 'inactive')>Inactive</option>
                </select>
                @error('status') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form__actions">
                <a href="{{ route('admin.characters.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Save Character</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.characters.partials.editor-assets')
