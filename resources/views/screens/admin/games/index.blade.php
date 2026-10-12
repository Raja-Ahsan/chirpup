@extends('layouts.admin.app')

@section('title', 'Games')
@section('page_title', 'Games')
@section('page_subtitle', 'Manage games by year')

@section('content')
    @if (session('success'))
        <div class="cu-alert cu-alert--success">{{ session('success') }}</div>
    @endif

    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.games.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by name"
                    aria-label="Search games"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $games->total() }} {{ $games->total() === 1 ? 'game' : 'games' }}</p>
                <a href="{{ route('admin.games.create') }}" class="cu-btn">Add Game</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Cover Book</th>
                        <th>Name</th>
                        <th>Slug</th>
                        <th>Year</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($games as $game)
                        <tr>
                            <td>
                                @if ($game->image_url)
                                    <img
                                        class="cu-thumb"
                                        src="{{ $game->image_path }}"
                                        alt="{{ $game->name }}"
                                    >
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>
                                @if ($game->cover_book_image)
                                    <img
                                        class="cu-thumb"
                                        src="{{ $game->cover_book_image_path }}"
                                        alt="{{ $game->name }} cover book"
                                    >
                                @else
                                    <span class="cu-muted">No cover</span>
                                @endif
                            </td>
                            <td>{{ $game->name }}</td>
                            <td>{{ $game->slug }}</td>
                            <td>{{ $game->year?->title ?? '—' }}</td>
                            <td>{{ $game->gameCategory?->title ?? '—' }}</td>
                            <td>
                                <span class="cu-badge {{ $game->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $game->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.games.edit', $game) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $game->name }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.games.destroy', $game) }}"
                                        onsubmit="return confirm('Delete this game?');"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $game->name }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="8" class="cu-empty">No games found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($games->hasPages())
            <div class="cu-pagination">
                @if ($games->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $games->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $games->currentPage() }} of {{ $games->lastPage() }}
                </span>

                @if ($games->hasMorePages())
                    <a href="{{ $games->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
