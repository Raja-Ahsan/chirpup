@extends('layouts.admin.app')

@section('title', 'Add Game')
@section('page_title', 'Add Game')
@section('page_subtitle', 'Create a new game')

@section('content')
    <section class="cu-card cu-form-card cu-form-card--wide">
        <form method="POST" action="{{ route('admin.games.store') }}" enctype="multipart/form-data" class="cu-form" novalidate>
            @csrf

            <div class="cu-field">
                <label for="name">Name <span class="cu-required">*</span></label>
                <input id="name" type="text" name="name" value="{{ old('name') }}">
                @error('name') <p class="cu-field__error">{{ $message }}</p> @enderror
            </div>

            <div class="cu-field">
                <label for="year_id">Year <span class="cu-required">*</span></label>
                <select id="year_id" name="year_id">
                    <option value="">Select year</option>
                    @foreach ($years as $year)
                        <option value="{{ $year->id }}" @selected(old('year_id') == $year->id)>
                            {{ $year->title }}
                        </option>
                    @endforeach
                </select>
                @error('year_id') <p class="cu-field__error">{{ $message }}</p> @enderror
                @if ($years->isEmpty())
                    <p class="cu-help">No active years available. Add years first.</p>
                @endif
            </div>

            <div class="cu-field">
                <label for="game_category_id">Category <span class="cu-required">*</span></label>
                <select id="game_category_id" name="game_category_id">
                    <option value="">Select category</option>
                    @foreach ($categories as $category)
                        <option value="{{ $category->id }}" @selected(old('game_category_id') == $category->id)>
                            {{ $category->title }}
                        </option>
                    @endforeach
                </select>
                @error('game_category_id') <p class="cu-field__error">{{ $message }}</p> @enderror
                @if ($categories->isEmpty())
                    <p class="cu-help">No active categories available. Add categories first.</p>
                @endif
            </div>

            <div class="cu-form-row cu-form-row--2">
                <div class="cu-field">
                    <label for="image">Image <span class="cu-required">*</span></label>
                    <label class="cu-image-area" for="image">
                        <img id="imagePreview" class="cu-image-area__preview" alt="Game preview" hidden>
                        <span class="cu-image-area__placeholder" id="imagePlaceholder">
                            <i class="fa-regular fa-image" aria-hidden="true"></i>
                            <strong>Click to upload game image</strong>
                            <small>PNG, JPG, or WEBP up to 4MB</small>
                        </span>
                        <input id="image" class="cu-image-area__input" type="file" name="image" accept="image/*">
                    </label>
                    @error('image') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>

                <div class="cu-field">
                    <label for="cover_book_image_file">Cover Book Image</label>
                    <label class="cu-image-area" for="cover_book_image_file">
                        <img id="coverBookPreview" class="cu-image-area__preview" alt="Cover book preview" hidden>
                        <span class="cu-image-area__placeholder" id="coverBookPlaceholder">
                            <i class="fa-regular fa-image" aria-hidden="true"></i>
                            <strong>Click to upload cover book image</strong>
                            <small>Optional · PNG, JPG, or WEBP up to 4MB</small>
                        </span>
                        <input id="cover_book_image_file" class="cu-image-area__input" type="file" name="cover_book_image_file" accept="image/*">
                    </label>
                    @error('cover_book_image_file') <p class="cu-field__error">{{ $message }}</p> @enderror
                </div>
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
                <a href="{{ route('admin.games.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Save Game</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.games.partials.editor-assets')
