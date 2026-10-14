@extends('layouts.admin.app')

@section('title', 'Characters')
@section('page_title', 'Characters')
@section('page_subtitle', 'Manage ChirpUp story characters')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.characters.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by name"
                    aria-label="Search characters"
                >
                <button type="submit">Search</button>
            </form>
            <div class="cu-toolbar__actions">
                <p class="cu-toolbar__meta">{{ $characters->total() }} {{ $characters->total() === 1 ? 'character' : 'characters' }}</p>
                <a href="{{ route('admin.characters.create') }}" class="cu-btn">Add Character</a>
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
                    @forelse ($characters as $character)
                        <tr>
                            <td>
                                @if ($character->image_url)
                                    <img
                                        class="cu-thumb"
                                        src="{{ $character->image_path }}"
                                        alt="{{ $character->name }}"
                                    >
                                @else
                                    <span class="cu-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $character->name }}</td>
                            <td>{{ $character->slug }}</td>
                            <td>
                                <span class="cu-badge {{ $character->status === 'active' ? 'cu-badge--ok' : 'cu-badge--warn' }}">
                                    {{ $character->status }}
                                </span>
                            </td>
                            <td>
                                <div class="cu-actions">
                                    <a
                                        href="{{ route('admin.characters.edit', $character) }}"
                                        class="cu-action-btn"
                                        title="Edit"
                                        aria-label="Edit {{ $character->name }}"
                                    >
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </a>
                                    <form
                                        method="POST"
                                        action="{{ route('admin.characters.destroy', $character) }}"
                                        class="cu-delete-form"
                                        data-confirm="Delete this character?"
                                    >
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="cu-action-btn cu-action-btn--danger"
                                            title="Delete"
                                            aria-label="Delete {{ $character->name }}"
                                        >
                                            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="cu-empty">No characters found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($characters->hasPages())
            <div class="cu-pagination">
                @if ($characters->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $characters->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $characters->currentPage() }} of {{ $characters->lastPage() }}
                </span>

                @if ($characters->hasMorePages())
                    <a href="{{ $characters->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>
@endsection
