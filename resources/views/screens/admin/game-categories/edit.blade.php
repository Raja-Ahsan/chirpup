@extends('layouts.admin.app')

@section('title', 'Edit Game Category')
@section('page_title', 'Edit Game Category')
@section('page_subtitle', 'Update game category details')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.game-categories.update', $category) }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf
            @method('PUT')

            <div class="cu-field">
                <label for="title">Title <span class="cu-required">*</span></label>
                <input id="title" type="text" name="title" value="{{ old('title', $category->title) }}">
                @error('title') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="image">Image</label>
                <label class="cu-image-area" for="image">
                    <img
                        id="imagePreview"
                        class="cu-image-area__preview"
                        src="{{ $category->image_path }}"
                        alt="{{ $category->title }}"
                        @if (! $category->image_url) hidden @endif
                    >
                    <span class="cu-image-area__placeholder" id="imagePlaceholder" @if ($category->image_url) hidden @endif>
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Click to upload category image</strong>
                        <small>PNG, JPG, or WEBP up to 4MB</small>
                    </span>
                    <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*">
                </label>
                <p class="cu-help">Leave empty to keep the current image.</p>
                @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="cu-editor">{{ old('description', $category->description) }}</textarea>
                @error('description') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label>Moods</label>
                <div class="cu-check-grid">
                    @forelse ($moods as $mood)
                        <label class="cu-check">
                            <input
                                type="checkbox"
                                name="mood_ids[]"
                                value="{{ $mood->id }}"
                                @checked(in_array($mood->id, $selectedMoodIds, false))
                            >
                            <span>{{ $mood->name }}</span>
                        </label>
                    @empty
                        <p class="cu-help">No active moods available. Add moods first.</p>
                    @endforelse
                </div>
                @error('mood_ids') <p class="cu-field__error">{{ $message }}</p> @enderror
                @error('mood_ids.*') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="status">Status <span class="cu-required">*</span></label>
                <select id="status" name="status">
                    <option value="active" @selected(old('status', $category->status) === 'active')>Active</option>
                    <option value="inactive" @selected(old('status', $category->status) === 'inactive')>Inactive</option>
                </select>
                @error('status') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-form__actions">
                <a href="{{ route('admin.game-categories.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Update Category</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.game-categories.partials.editor-assets')
