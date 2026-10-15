<header class="cu-topbar">
    <div class="cu-topbar__title">
        <button
            type="button"
            class="cu-menu-btn"
            id="cuMenuToggle"
            aria-label="Open navigation"
            aria-controls="cuSidebar"
            aria-expanded="false"
        >
            <i class="fa-solid fa-bars" aria-hidden="true"></i>
        </button>
        <div class="cu-topbar__heading">
            <h1>@yield('page_title', 'Dashboard')</h1>
            <p>@yield('page_subtitle', 'Manage your ChirpUp kingdom')</p>
        </div>
    </div>

    <div class="cu-user">
        <div class="cu-user__meta">
            <strong>{{ auth()->user()->name ?? 'Admin' }}</strong>
            <span>{{ formatRole(auth()->user()->role ?? 'admin') }}</span>
        </div>

        <form method="POST" action="{{ route('admin.logout') }}">
            @csrf
            <button class="cu-logout" type="submit" aria-label="Log out">
                <i class="fa-solid fa-arrow-right-from-bracket" aria-hidden="true"></i>
                <span class="cu-logout__text">Log out</span>
            </button>
        </form>
    </div>
</header>
