@extends('layouts.admin.app')

@section('title', 'Games')
@section('page_title', 'Games')
@section('page_subtitle', 'Choose a game category')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <p class="cu-toolbar__meta">{{ $categories->count() }} {{ $categories->count() === 1 ? 'category' : 'categories' }}</p>
        </div>

        @if ($categories->isEmpty())
            <p class="cu-empty">No game categories found.</p>
        @else
            <div class="cu-category-grid">
                @foreach ($categories as $category)
                    <a href="{{ route('admin.games.by-category', $category) }}" class="cu-category-card">
                        <div class="cu-category-card__media">
                            @if ($category->image_url)
                                <img src="{{ $category->image_path }}" alt="{{ $category->title }}">
                            @else
                                <span class="cu-category-card__placeholder">
                                    <i class="fa-solid fa-layer-group" aria-hidden="true"></i>
                                </span>
                            @endif
                        </div>
                        <div class="cu-category-card__body">
                            <h3>{{ $category->title }}</h3>
                            <p>{{ $category->games_count }} {{ $category->games_count === 1 ? 'game' : 'games' }}</p>
                            <span class="cu-badge {{ $category->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                {{ $category->status }}
                            </span>
                        </div>
                    </a>
                @endforeach
            </div>
        @endif
    </section>
@endsection
