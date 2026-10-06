@extends('layouts.admin.app')

@section('title', 'Users')
@section('page_title', 'Users')
@section('page_subtitle', 'Registered ChirpUp accounts')

@section('content')
    <section class="cu-card">
        <div class="cu-toolbar">
            <form method="GET" action="{{ route('admin.users.index') }}" class="cu-search">
                <input
                    type="search"
                    name="q"
                    value="{{ $search }}"
                    placeholder="Search by name or email"
                    aria-label="Search users"
                >
                <button type="submit">Search</button>
            </form>
            <p class="cu-toolbar__meta">{{ $users->total() }} {{ $users->total() === 1 ? 'user' : 'users' }}</p>
        </div>

        <div class="cu-table-wrap">
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Total Character</th>
                        <th>Role</th>
                        <th>Verified</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($users as $user)
                        @php
                            $charactersPayload = $user->children->map(function ($child) {
                                return [
                                    'child_name' => $child->name,
                                    'character_name' => $child->character?->name ?? '—',
                                    'character_image' => $child->character?->image_path,
                                    'year' => $child->year?->title ?? '—',
                                ];
                            })->values();
                        @endphp
                        <tr>
                            <td>{{ $user->name }}</td>
                            <td>{{ $user->email }}</td>
                            <td>
                                @if ($user->total_characters > 0)
                                    <button
                                        type="button"
                                        class="cu-link-btn"
                                        data-characters-view
                                        data-user-name="{{ $user->name }}"
                                        data-characters='@json($charactersPayload)'
                                    >
                                        {{ $user->total_characters }}
                                    </button>
                                @else
                                    <span class="cu-muted">0</span>
                                @endif
                            </td>
                            <td>
                                <span class="cu-badge {{ $user->role === 'admin' ? 'cu-badge--admin' : 'cu-badge--user' }}">
                                    {{ $user->role }}
                                </span>
                            </td>
                            <td>
                                @if ($user->email_verified_at)
                                    <span class="cu-badge cu-badge--ok">Verified</span>
                                @else
                                    <span class="cu-badge cu-badge--warn">Pending</span>
                                @endif
                            </td>
                            <td>
                                <button
                                    type="button"
                                    class="cu-action-btn"
                                    title="View user"
                                    aria-label="View {{ $user->name }}"
                                    data-user-view
                                    data-name="{{ $user->name }}"
                                    data-email="{{ $user->email }}"
                                    data-children='@json($charactersPayload)'
                                >
                                    <i class="fa-regular fa-eye" aria-hidden="true"></i>
                                </button>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="cu-empty">No users found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if ($users->hasPages())
            <div class="cu-pagination">
                @if ($users->onFirstPage())
                    <span class="is-disabled">Previous</span>
                @else
                    <a href="{{ $users->previousPageUrl() }}">Previous</a>
                @endif

                <span class="cu-pagination__status">
                    Page {{ $users->currentPage() }} of {{ $users->lastPage() }}
                </span>

                @if ($users->hasMorePages())
                    <a href="{{ $users->nextPageUrl() }}">Next</a>
                @else
                    <span class="is-disabled">Next</span>
                @endif
            </div>
        @endif
    </section>

    <div class="cu-modal" id="userViewModal" hidden>
        <div class="cu-modal__backdrop" data-close-modal></div>
        <div class="cu-modal__dialog cu-modal__dialog--wide" role="dialog" aria-modal="true" aria-labelledby="userViewTitle">
            <div class="cu-modal__header">
                <h2 id="userViewTitle">User details</h2>
                <button type="button" class="cu-modal__close" data-close-modal aria-label="Close">
                    <i class="fa-solid fa-xmark" aria-hidden="true"></i>
                </button>
            </div>
            <div class="cu-modal__body">
                <dl class="cu-detail-list">
                    <div>
                        <dt>Name</dt>
                        <dd data-field="name">—</dd>
                    </div>
                    <div>
                        <dt>Email</dt>
                        <dd data-field="email">—</dd>
                    </div>
                </dl>

                <div class="cu-modal-section" id="userChildrenSection" hidden>
                    <h3 class="cu-modal-section__title">Child profiles</h3>
                    <div class="cu-character-list" id="userChildrenList"></div>
                </div>
            </div>
            <div class="cu-modal__footer">
                <button type="button" class="cu-modal__btn" data-close-modal>Close</button>
            </div>
        </div>
    </div>

    <div class="cu-modal" id="charactersViewModal" hidden>
        <div class="cu-modal__backdrop" data-close-characters-modal></div>
        <div class="cu-modal__dialog cu-modal__dialog--wide" role="dialog" aria-modal="true" aria-labelledby="charactersViewTitle">
            <div class="cu-modal__header">
                <h2 id="charactersViewTitle">Characters</h2>
                <button type="button" class="cu-modal__close" data-close-characters-modal aria-label="Close">
                    <i class="fa-solid fa-xmark" aria-hidden="true"></i>
                </button>
            </div>
            <div class="cu-modal__body">
                <div class="cu-character-list" id="charactersList"></div>
                <p class="cu-empty" id="charactersEmpty" hidden>No characters found.</p>
            </div>
            <div class="cu-modal__footer">
                <button type="button" class="cu-modal__btn" data-close-characters-modal>Close</button>
            </div>
        </div>
    </div>
@endsection

@push('scripts')
<script>
  (function () {
    var userModal = document.getElementById('userViewModal');
    var charactersModal = document.getElementById('charactersViewModal');
    var charactersList = document.getElementById('charactersList');
    var charactersEmpty = document.getElementById('charactersEmpty');
    var charactersTitle = document.getElementById('charactersViewTitle');
    var userChildrenSection = document.getElementById('userChildrenSection');
    var userChildrenList = document.getElementById('userChildrenList');

    function renderChildCards(container, items) {
      container.innerHTML = '';
      items.forEach(function (item) {
        var row = document.createElement('div');
        row.className = 'cu-character-item';
        row.innerHTML =
          (item.character_image
            ? '<img class="cu-character-item__img" src="' + item.character_image + '" alt="' + (item.character_name || '') + '">'
            : '<div class="cu-character-item__img cu-character-item__img--empty"><i class="fa-regular fa-image"></i></div>') +
          '<div class="cu-character-item__meta">' +
            '<strong>' + (item.child_name || '—') + '</strong>' +
            '<span>Character: ' + (item.character_name || '—') + '</span>' +
            '<span>Year: ' + (item.year || '—') + '</span>' +
          '</div>';
        container.appendChild(row);
      });
    }

    function openUserModal(btn) {
      var children = [];
      try {
        children = JSON.parse(btn.getAttribute('data-children') || '[]');
      } catch (e) {
        children = [];
      }

      userModal.querySelector('[data-field="name"]').textContent = btn.dataset.name || '—';
      userModal.querySelector('[data-field="email"]').textContent = btn.dataset.email || '—';

      if (children.length) {
        userChildrenSection.hidden = false;
        renderChildCards(userChildrenList, children);
      } else {
        userChildrenSection.hidden = true;
        userChildrenList.innerHTML = '';
      }

      userModal.hidden = false;
      document.body.classList.add('cu-modal-open');
    }

    function closeUserModal() {
      userModal.hidden = true;
      if (charactersModal.hidden) {
        document.body.classList.remove('cu-modal-open');
      }
    }

    function openCharactersModal(btn) {
      var items = [];
      try {
        items = JSON.parse(btn.getAttribute('data-characters') || '[]');
      } catch (e) {
        items = [];
      }

      charactersTitle.textContent = (btn.dataset.userName || 'User') + ' — Characters';
      charactersList.innerHTML = '';

      if (!items.length) {
        charactersEmpty.hidden = false;
        charactersList.innerHTML = '';
      } else {
        charactersEmpty.hidden = true;
        renderChildCards(charactersList, items);
      }

      charactersModal.hidden = false;
      document.body.classList.add('cu-modal-open');
    }

    function closeCharactersModal() {
      charactersModal.hidden = true;
      if (userModal.hidden) {
        document.body.classList.remove('cu-modal-open');
      }
    }

    document.querySelectorAll('[data-user-view]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        openUserModal(btn);
      });
    });

    document.querySelectorAll('[data-characters-view]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        openCharactersModal(btn);
      });
    });

    userModal.querySelectorAll('[data-close-modal]').forEach(function (el) {
      el.addEventListener('click', closeUserModal);
    });

    charactersModal.querySelectorAll('[data-close-characters-modal]').forEach(function (el) {
      el.addEventListener('click', closeCharactersModal);
    });

    document.addEventListener('keydown', function (event) {
      if (event.key !== 'Escape') return;
      if (!charactersModal.hidden) {
        closeCharactersModal();
        return;
      }
      if (!userModal.hidden) {
        closeUserModal();
      }
    });
  })();
</script>
@endpush
