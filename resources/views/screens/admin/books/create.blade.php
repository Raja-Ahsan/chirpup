@extends('layouts.admin.app')

@section('title', 'Add Book')
@section('page_title', 'Add Book')
@section('page_subtitle', 'Create a new book')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.books.store') }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf

            <div class="cu-field">
                <label for="title">Title <span class="cu-required">*</span></label>
                <input id="title" type="text" name="title" value="{{ old('title') }}">
                @error('title') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="image">Image <span class="cu-required">*</span></label>
                <label class="cu-image-area" for="image">
                    <img id="imagePreview" class="cu-image-area__preview" alt="Book preview" hidden>
                    <span class="cu-image-area__placeholder" id="imagePlaceholder">
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload book image</strong>
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
                <a href="{{ route('admin.books.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Save Book</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.books.partials.editor-assets')
