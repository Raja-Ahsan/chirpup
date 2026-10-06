<header class="cu-topbar">
    <div>
        <h1>@yield('page_title', 'Dashboard')</h1>
        <p>@yield('page_subtitle', 'Manage your ChirpUp kingdom')</p>
    </div>

    <div class="cu-user">
        <div class="cu-user__meta">
            <strong>{{ auth()->user()->name ?? 'Admin' }}</strong>
            <span>{{ formatRole(auth()->user()->role ?? 'admin') }}</span>
        </div>

        <form method="POST" action="{{ route('admin.logout') }}">
            @csrf
            <button class="cu-logout" type="submit">Log out</button>
        </form>
    </div>
</header>
