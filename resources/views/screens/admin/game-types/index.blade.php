@extends('layouts.admin.app')

@section('title', 'Games Type')
@section('page_title', 'Games Type')
@section('page_subtitle', 'Manage game types by category, year, and game')

@section('content')
    @if (session('success'))
        <div class="cu-alert cu-alert--success">{{ session('success') }}</div>
    @endif

    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.game-types.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by name"
                    aria-label="Search game types"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $gameTypes->total() }} {{ $gameTypes->total() === 1 ? 'type' : 'types' }}</p>
                <a href="{{ route('admin.game-types.create') }}" class="cu-btn">Add Game Type</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Sketch</th>
                        <th>Color</th>
                        <th>Name</th>
                        <th>Game</th>
                        <th>Year</th>
                        <th>Category</th>
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
                            <td>{{ $gameType->game?->name ?? '—' }}</td>
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
                                        onsubmit="return confirm('Delete this game type?');"
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
                            <td colspan="10" class="cu-empty">No game types found.</td>
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
