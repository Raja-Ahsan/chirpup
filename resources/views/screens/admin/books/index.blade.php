@extends('layouts.admin.app')

@section('title', 'Books')
@section('page_title', 'Books')
@section('page_subtitle', 'Manage ChirpUp books')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.books.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by title"
                    aria-label="Search books"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $books->total() }} {{ $books->total() === 1 ? 'book' : 'books' }}</p>
                <a href="{{ route('admin.books.create') }}" class="cu-btn">Add Book</a>
            </div>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Slug</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($books as $book)
                        <tr>
                            <td>
                                @if ($book->image_url)
                                    <img class="cu-thumb" src="{{ $book->image_path }}" alt="{{ $book->title }}">
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $book->title }}</td>
                            <td>{{ $book->slug }}</td>
                            <td>
                                <span class="cu-badge {{ $book->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $book->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.books.edit', $book) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $book->title }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.books.destroy', $book) }}"
                                        class="cu-delete-form"
                                        data-confirm="Delete this book?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $book->title }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="cu-empty">No books found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($books->hasPages())
            <div class="cu-pagination">
                @if ($books->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $books->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $books->currentPage() }} of {{ $books->lastPage() }}
                </span>

                @if ($books->hasMorePages())
                    <a href="{{ $books->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
