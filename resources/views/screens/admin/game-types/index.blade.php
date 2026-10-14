@extends('layouts.admin.app')

@section('title', 'Game')
@section('page_title', 'Game')
@section('page_subtitle', 'Choose a game type')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.game-types.index') }}" class="cu-filter">
                <label for="categoryFilter">Select Game Category</label>
                <select id="categoryFilter" name="game_category_id" aria-label="Select Game Category" onchange="this.form.submit()">
                    <option value="">Select Game Category</option>
                    @foreach ($categories as $category)
                        <option value="{{ $category->id }}" @selected((string) $selectedCategoryId === (string) $category->id)>
                            {{ $category->title }}
                        </option>
                    @endforeach
                </select>
            </form>
            <p class="cu-toolbar__meta">{{ $games->count() }} {{ $games->count() === 1 ? 'game type' : 'game types' }}</p>
        </div>

        @if ($games->isEmpty())
            <p class="cu-empty">No game types found{{ $selectedCategoryId ? ' for this game category' : '' }}.</p>
        @else
            <div class="cu-category-grid">
                @foreach ($games as $game)
                    <a href="{{ route('admin.game-types.by-game', $game) }}" class="cu-category-card">
                        <div class="cu-category-card__media">
                            @if ($game->image_url)
                                <img src="{{ $game->image_path }}" alt="{{ $game->name }}">
                            @else
                                <span class="cu-category-card__placeholder">
                                    <i class="fa-solid fa-puzzle-piece" aria-hidden="true"></i>
                                </span>
                            @endif
                        </div>
                        <div class="cu-category-card__body">
                            <h3>{{ $game->name }}</h3>
                            <p>{{ $game->game_types_count }} {{ $game->game_types_count === 1 ? 'game' : 'games' }}</p>
                            <span class="cu-badge {{ $game->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                {{ $game->status }}
                            </span>
                        </div>
                    </a>
                @endforeach
            </div>
        @endif
    </section>
@endsection
