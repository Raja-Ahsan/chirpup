@extends('layouts.admin.app')

@section('title', 'Add Game Type')
@section('page_title', 'Add Game Type')
@section('page_subtitle', 'Create a new game type')

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
            </div>

            <div class="cu-field">
                <label for="game_id">Game <span class="cu-required">*</span></label>
                <select id="game_id" name="game_id">
                    <option value="">Select game</option>
                    @foreach ($games as $game)
                        <option
                            value="{{ $game->id }}"
                            data-year-id="{{ $game->year_id }}"
                            data-category-id="{{ $game->game_category_id }}"
                            @selected(old('game_id') == $game->id)
                        >
                            {{ $game->name }} ({{ $game->year?->title ?? 'Year '.$game->year_id }})
                        </option>
                    @endforeach
                </select>
                @error('game_id') <p class="cu-field__error">{{ $message }}</p> @enderror
                <p class="cu-help">Games are filtered by the selected category and year.</p>
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
                    <label for="color_image">Color Image <span class="cu-required">*</span></label>
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
                        <p class="cu-help">Add extra sketch items for this game type.</p>
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
                <a href="{{ route('admin.game-types.index') }}" class="cu-btn cu-btn--ghost">Cancel</a>
                <button type="submit" class="cu-btn">Save Game Type</button>
            </div>
        </form>
    </section>
@endsection

@include('screens.admin.game-types.partials.editor-assets')
