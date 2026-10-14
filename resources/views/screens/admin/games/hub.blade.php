@extends('layouts.admin.app')

@section('title', $category->title)
@section('page_title', $category->title)
@section('page_subtitle', 'Choose a section')

@section('content')
    <section class="cu-card">
        <div class="cu-category-grid">
            <a href="{{ route('admin.games.category-games', $category) }}" class="cu-category-card">
                <div class="cu-category-card__media">
                    <span class="cu-category-card__placeholder">
                        <i class="fa-solid fa-gamepad" aria-hidden="true"></i>
                    </span>
                </div>
                <div class="cu-category-card__body">
                    <h3>Games</h3>
                    <p>{{ $gamesCount }} {{ $gamesCount === 1 ? 'game' : 'games' }}</p>
                </div>
            </a>

            <a href="{{ route('admin.game-book-years.index', $category) }}" class="cu-category-card">
                <div class="cu-category-card__media">
                    <span class="cu-category-card__placeholder">
                        <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                    </span>
                </div>
                <div class="cu-category-card__body">
                    <h3>Game Book & Year</h3>
                    <p>{{ $bookYearCount }} {{ $bookYearCount === 1 ? 'record' : 'records' }}</p>
                </div>
            </a>

            <a href="{{ route('admin.sketches.index', $category) }}" class="cu-category-card">
                <div class="cu-category-card__media">
                    <span class="cu-category-card__placeholder">
                        <i class="fa-solid fa-pencil" aria-hidden="true"></i>
                    </span>
                </div>
                <div class="cu-category-card__body">
                    <h3>Sketches</h3>
                    <p>{{ $sketchesCount }} {{ $sketchesCount === 1 ? 'game' : 'games' }}</p>
                </div>
            </a>
        </div>
    </section>
@endsection

