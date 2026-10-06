@php
    $modules = dynamic_sidebar();
@endphp

<div class="sidebar-wrapper" data-sidebar-layout="stroke-svg">
    <div class="logo-wrapper">
        <a href="{{ route('admin.dashboard') }}">
            <img class="img-fluid" src="{{ asset('assets/admin/images/brand/chirpup-logo.png') }}" alt="ChirpUp" style="max-width: 160px" />
        </a>

        <div class="back-btn">
            <i class="fa-solid fa-angle-left"></i>
        </div>
    </div>

    <nav class="sidebar-main">
        <div class="left-arrow" id="left-arrow">
            <i data-feather="arrow-left"></i>
        </div>

        <div id="sidebar-menu">
            <ul class="sidebar-links" id="simple-bar">
                <li class="back-btn">
                    <div class="mobile-back text-end">
                        <span>Back</span>
                        <i class="fa-solid fa-angle-right ps-2" aria-hidden="true"></i>
                    </div>
                </li>

                <li class="pin-title sidebar-main-title">
                    <div>
                        <h6>Pinned</h6>
                    </div>
                </li>

                @foreach ($modules as $module)
                    @php
                        $hasChildren = $module->children && $module->children->count() > 0;
                    @endphp

                    <li class="sidebar-list">
                        <i class="fa-solid fa-thumbtack"></i>

                        <a
                            href="{{ $hasChildren ? '#' : (Route::has($module->route_name) ? route($module->route_name) : '#') }}"
                            class="sidebar-link sidebar-title {{ $hasChildren ? '' : 'link-nav' }}"
                            @if ($hasChildren) aria-expanded="false" @endif
                        >
                            <span class="theme-icons">
                                <i class="{{ $module->icon }}"></i>
                            </span>

                            <span>{{ $module->name }}</span>

                            @if ($hasChildren)
                                <div class="according-menu">
                                    <i class="fa-solid fa-angle-right"></i>
                                </div>
                            @endif
                        </a>

                        @if ($hasChildren)
                            <ul class="sidebar-submenu">
                                @foreach ($module->children as $child)
                                    <li>
                                        <a href="{{ Route::has($child->route_name) ? route($child->route_name) : '#' }}">
                                            {{ $child->name }}
                                        </a>
                                    </li>
                                @endforeach
                            </ul>
                        @endif
                    </li>
                @endforeach
            </ul>
        </div>

        <div class="right-arrow" id="right-arrow">
            <i data-feather="arrow-right"></i>
        </div>
    </nav>
</div>