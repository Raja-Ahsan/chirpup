@extends('layouts.admin.app')

@section('title', $category->title.' — Game Book & Year')
@section('page_title', $category->title)
@section('page_subtitle', 'Game Book & Year')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <p class="cu-toolbar__meta">{{ $items->total() }} {{ $items->total() === 1 ? 'record' : 'records' }}</p>
            <div class="cu-toolbar__actions">
                <form method="GET" action="{{ route('admin.game-book-years.index', $category) }}" class="cu-search">
                    <input
                        type="search"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Search by game, book, or year"
                        aria-label="Search game book year"
                    >
                    <button type="submit" class="cu-btn" aria-label="Search">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                    </button>
                </form>
                <a href="{{ route('admin.game-book-years.create', $category) }}" class="cu-btn">
                    <i class="fa-solid fa-plus" aria-hidden="true"></i>
                    Add Game Book & Year
                </a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Game</th>
                        <th>Year</th>
                        <th>Book</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($items as $item)
                        <tr>
                            <td>
                                @if ($item->image_url)
                                    <img class="cu-thumb" src="{{ $item->image_path }}" alt="">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $item->game?->name ?? '—' }}</td>
                            <td>{{ $item->year?->title ?? '—' }}</td>
                            <td>
                                @if ($item->relatedBooks->isNotEmpty())
                                    {{ $item->relatedBooks->pluck('book.title')->filter()->join(', ') }}
                                @else
                                    <span class="cu-muted">—</span>
                                @endif
                            </td>
                            <td>
                                <span class="cu-badge {{ $item->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $item->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.game-book-years.edit', [$category, $item]) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit record"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.game-book-years.destroy', [$category, $item]) }}"
                                        class="cu-delete-form"
                                        data-confirm="Delete this Game Book & Year record?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete record"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="cu-empty">No Game Book & Year records found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($items->hasPages())
            <div class="cu-pagination">
                @if ($items->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $items->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $items->currentPage() }} of {{ $items->lastPage() }}
                </span>

                @if ($items->hasMorePages())
                    <a href="{{ $items->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
