@extends('layouts.admin.app')

@section('title', 'Game Categories')
@section('page_title', 'Game Categories')
@section('page_subtitle', 'Manage game categories and linked moods')

@section('content')
    @if (session('success'))
        <div class="cu-alert cu-alert--success">{{ session('success') }}</div>
    @endif

    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.game-categories.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by title"
                    aria-label="Search game categories"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $categories->total() }} {{ $categories->total() === 1 ? 'category' : 'categories' }}</p>
                <a href="{{ route('admin.game-categories.create') }}" class="cu-btn">Add Category</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Slug</th>
                        <th>Moods</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($categories as $category)
                        <tr>
                            <td>
                                @if ($category->image_url)
                                    <img
                                        class="cu-thumb"
                                        src="{{ $category->image_path }}"
                                        alt="{{ $category->title }}"
                                    >
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $category->title }}</td>
                            <td>{{ $category->slug }}</td>
                            <td>{{ $category->moods_count }}</td>
                            <td>
                                <span class="cu-badge {{ $category->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $category->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.game-categories.edit', $category) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $category->title }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.game-categories.destroy', $category) }}"
                                        onsubmit="return confirm('Delete this category?');"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $category->title }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="cu-empty">No game categories found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($categories->hasPages())
            <div class="cu-pagination">
                @if ($categories->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $categories->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $categories->currentPage() }} of {{ $categories->lastPage() }}
                </span>

                @if ($categories->hasMorePages())
                    <a href="{{ $categories->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
