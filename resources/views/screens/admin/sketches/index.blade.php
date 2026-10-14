@extends('layouts.admin.app')

@section('title', $category->title.' — Sketches')
@section('page_title', $category->title)
@section('page_subtitle', 'Sketches')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.sketches.index', $category) }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by name"
                    aria-label="Search sketches"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $gameTypes->total() }} {{ $gameTypes->total() === 1 ? 'game' : 'games' }}</p>
                <a
                    href="{{ route('admin.game-types.create', ['game_category_id' => $category->id]) }}"
                    class="cu-btn"
                >Add Game</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Game</th>
                        <th>Year</th>
                        <th>Book</th>
                        <th>Sketches</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($gameTypes as $gameType)
                        <tr>
                            <td>
                                @if ($gameType->sketch_image_url)
                                    <img class="cu-thumb" src="{{ $gameType->sketch_image_path }}" alt="{{ $gameType->name }}">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $gameType->name }}</td>
                            <td>{{ $gameType->game?->name ?? '—' }}</td>
                            <td>{{ $gameType->year?->title ?? '—' }}</td>
                            <td>{{ $gameType->book?->title ?? '—' }}</td>
                            <td>{{ $gameType->sketches_count }}</td>
                            <td>
                                <span class="cu-badge {{ $gameType->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $gameType->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.game-types.edit', $gameType) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $gameType->name }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.game-types.destroy', $gameType) }}"
                                        class="cu-inline-form"
                                        data-confirm="Delete this game and its sketches?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="cu-action-btn cu-action-btn--danger" title="Delete" aria-label="Delete {{ $gameType->name }}">
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="8" class="cu-empty">No games found in this game category.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($gameTypes->hasPages())
            <div class="cu-pagination">
                @if ($gameTypes->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $gameTypes->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $gameTypes->currentPage() }} of {{ $gameTypes->lastPage() }}
                </span>

                @if ($gameTypes->hasMorePages())
                    <a href="{{ $gameTypes->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
