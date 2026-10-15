@extends('layouts.admin.app')

@section('title', 'Game Moods')
@section('page_title', 'Game Moods')
@section('page_subtitle', 'Manage moods for ChirpUp games')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <p class="cu-toolbar__meta">{{ $moods->total() }} {{ $moods->total() === 1 ? 'mood' : 'moods' }}</p>
            <div class="cu-toolbar__actions">
                <form method="GET" action="{{ route('admin.game-moods.index') }}" class="cu-search">
                    <input
                        type="search"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Search by name"
                        aria-label="Search game moods"
                    >
                    <button type="submit" class="cu-btn" aria-label="Search">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                    </button>
                </form>
                <a href="{{ route('admin.game-moods.create') }}" class="cu-btn">
                    <i class="fa-solid fa-plus" aria-hidden="true"></i>
                    Add Mood
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
                    @forelse ($moods as $mood)
                        <tr>
                            <td>
                                @if ($mood->image_url)
                                    <img
                                        class="cu-thumb"
                                        src="{{ $mood->image_path }}"
                                        alt="{{ $mood->name }}"
                                    >
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $mood->name }}</td>
                            <td>{{ $mood->slug }}</td>
                            <td>
                                <span class="cu-badge {{ $mood->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $mood->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.game-moods.edit', $mood) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $mood->name }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.game-moods.destroy', $mood) }}"
                                        class="cu-delete-form"
                                        data-confirm="Delete this mood?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $mood->name }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="cu-empty">No game moods found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($moods->hasPages())
            <div class="cu-pagination">
                @if ($moods->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $moods->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $moods->currentPage() }} of {{ $moods->lastPage() }}
                </span>

                @if ($moods->hasMorePages())
                    <a href="{{ $moods->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
