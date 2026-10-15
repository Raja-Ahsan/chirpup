@php
    $modules = dynamic_sidebar();
@endphp

<aside class="cu-sidebar" id="cuSidebar">
    <div class="cu-sidebar__top">
        <a class="cu-sidebar__brand" href="{{ route('admin.dashboard') }}">
            <img src="{{ asset('assets/admin/images/brand/chirpup-logo.png') }}" alt="ChirpUp" />
        </a>
        <button type="button" class="cu-sidebar__close" id="cuSidebarClose" aria-label="Close navigation">
            <i class="fa-solid fa-xmark" aria-hidden="true"></i>
        </button>
    </div>

    <nav class="cu-sidebar__nav" aria-label="Admin navigation">
        <p class="cu-nav-label">Main</p>
        <ul class="cu-nav">
            @foreach ($modules as $module)
                @php
                    $hasChildren = $module->children && $module->children->count() > 0;
                    $childActive = $hasChildren && $module->children->contains(function ($child) {
                        return sidebar_route_is_active($child->route_name);
                    });
                    $isActive = (!$hasChildren && sidebar_route_is_active($module->route_name))
                        || $childActive;
                    $moduleUrl = $hasChildren ? '#' : sidebar_module_url($module->route_name);
                @endphp

                <li class="cu-nav__item {{ $hasChildren ? 'has-children' : '' }} {{ $isActive ? 'is-open is-active' : '' }}">
                    @if ($hasChildren)
                        <button
                            type="button"
                            class="cu-nav__link cu-nav__toggle {{ $isActive ? 'is-active' : '' }}"
                            aria-expanded="{{ $isActive ? 'true' : 'false' }}">
                            <span class="cu-nav__icon"><i class="{{ $module->icon ?: 'fa-solid fa-folder' }}"></i></span>
                            <span class="cu-nav__text">{{ $module->name }}</span>
                            <span class="cu-nav__chevron"><i class="fa-solid fa-chevron-right"></i></span>
                        </button>
                        <ul class="cu-nav__children" @if(!$isActive) hidden @endif>
                            @foreach ($module->children as $child)
                                @php
                                    $childUrl = sidebar_module_url($child->route_name);
                                    $childIsActive = sidebar_route_is_active($child->route_name);
                                @endphp
                                <li>
                                    <a href="{{ $childUrl }}" class="cu-nav__sublink {{ $childIsActive ? 'is-active' : '' }}">
                                        {{ $child->name }}
                                    </a>
                                </li>
                            @endforeach
                        </ul>
                    @else
                        <a href="{{ $moduleUrl }}" class="cu-nav__link {{ $isActive ? 'is-active' : '' }}">
                            <span class="cu-nav__icon"><i class="{{ $module->icon ?: 'fa-solid fa-circle' }}"></i></span>
                            <span class="cu-nav__text">{{ $module->name }}</span>
                        </a>
                    @endif
                </li>
            @endforeach
        </ul>
    </nav>

    <div class="cu-sidebar__foot">
        <span>{{ auth()->user()->name ?? 'Admin' }}</span>
        <small>Signed in</small>
    </div>
</aside>
