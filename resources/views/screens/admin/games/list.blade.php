@extends('layouts.admin.app')

@section('title', $category->title.' Games')
@section('page_title', $category->title)
@section('page_subtitle', 'Games in this game category')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <p class="cu-toolbar__meta">{{ $games->total() }} {{ $games->total() === 1 ? 'game' : 'games' }}</p>
            <div class="cu-toolbar__actions">
                <form method="GET" action="{{ route('admin.games.category-games', $category) }}" class="cu-search">
                    <input
                        type="search"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Search by name"
                        aria-label="Search games"
                    >
                    <button type="submit" class="cu-btn" aria-label="Search">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                    </button>
                </form>
                <a href="{{ route('admin.games.create', ['game_category_id' => $category->id]) }}" class="cu-btn">
                    <i class="fa-solid fa-plus" aria-hidden="true"></i>
                    Add Game
                </a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Slug</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($games as $game)
                        <tr>
                            <td>
                                @if ($game->image_url)
                                    <img class="cu-thumb" src="{{ $game->image_path }}" alt="{{ $game->name }}">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $game->name }}</td>
                            <td>{{ $game->slug }}</td>
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
                                        class="cu-delete-form"
                                        data-confirm="Delete this game?"
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
                            <td colspan="5" class="cu-empty">No games found in this game category.</td>
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
