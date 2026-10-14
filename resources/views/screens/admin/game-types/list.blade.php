@extends('layouts.admin.app')

@section('title', $game->name.' Games')
@section('page_title', $game->name)
@section('page_subtitle', 'Games in this game type')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <div class="cu-toolbar__filters">
                <form method="GET" action="{{ route('admin.game-types.by-game', $game) }}" class="cu-filter" id="categoryFilterForm">
                    <label for="categoryFilter">Select Game Category</label>
                    <select id="categoryFilter" name="game_category_id" aria-label="Select Game Category" onchange="this.form.submit()">
                        <option value="">Select Game Category</option>
                        @foreach ($categories as $category)
                            <option value="{{ $category->id }}" @selected((string) $selectedCategoryId === (string) $category->id)>
                                {{ $category->title }}
                            </option>
                        @endforeach
                    </select>
                    @if ($search !== '')
                        <input type="hidden" name="q" value="{{ $search }}">
                    @endif
                </form>
                <form method="GET" action="{{ route('admin.game-types.by-game', $game) }}" class="cu-search">
                    @if ($selectedCategoryId)
                        <input type="hidden" name="game_category_id" value="{{ $selectedCategoryId }}">
                    @endif
                    <input
                        type="search"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Search by name"
                        aria-label="Search games"
                    >
                    <button type="submit">Search</button>
                </form>
            </div>
            <div class="cu-toolbar__actions">
                <a href="{{ route('admin.game-types.index') }}" class="cu-btn cu-btn--ghost">All Game Types</a>
                <p class="cu-toolbar__meta">{{ $gameTypes->total() }} {{ $gameTypes->total() === 1 ? 'game' : 'games' }}</p>
                <a href="{{ route('admin.game-types.create', ['game_id' => $game->id]) }}" class="cu-btn">Add Game</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Sketch</th>
                        <th>Color</th>
                        <th>Name</th>
                        <th>Year</th>
                        <th>Game Category</th>
                        <th>Points</th>
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
                                    <img class="cu-thumb" src="{{ $gameType->sketch_image_path }}" alt="{{ $gameType->name }} sketch">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>
                                @if ($gameType->color_image_url)
                                    <img class="cu-thumb" src="{{ $gameType->color_image_path }}" alt="{{ $gameType->name }} color">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $gameType->name }}</td>
                            <td>{{ $gameType->year?->title ?? '—' }}</td>
                            <td>{{ $gameType->gameCategory?->title ?? '—' }}</td>
                            <td>{{ $gameType->points }}</td>
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
                                        class="cu-delete-form"
                                        data-confirm="Delete this game?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $gameType->name }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="9" class="cu-empty">No games found in this game type.</td>
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
