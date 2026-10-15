<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="csrf-token" content="{{ csrf_token() }}" />
    <title>@yield('title', 'Dashboard') — ChirpUp Admin</title>
    <link rel="icon" href="{{ asset('assets/admin/images/favicon.png') }}" type="image/x-icon" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&family=Sora:wght@500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="{{ asset('assets/admin/css/vendors/sweetalert2.css') }}" />
    <link rel="stylesheet" href="{{ asset('assets/admin/css/chirpup-panel.css') }}" />
    @stack('styles')
</head>
<body class="cu-panel">
    <div id="cuPageLoader" class="cu-page-loader is-visible" aria-live="polite" aria-busy="true">
        <div class="cu-page-loader__inner">
            <div class="cu-page-loader__orb" aria-hidden="true">
                <span class="cu-page-loader__glow"></span>
                <span class="cu-page-loader__ring cu-page-loader__ring--outer"></span>
                <span class="cu-page-loader__ring cu-page-loader__ring--mid"></span>
                <span class="cu-page-loader__ring cu-page-loader__ring--inner"></span>
                <span class="cu-page-loader__core">
                    <span class="cu-page-loader__spark"></span>
                </span>
            </div>
            <img
                class="cu-page-loader__brand"
                src="{{ asset('assets/admin/images/brand/chirpup-logo.png') }}"
                alt="ChirpUp"
            >
            <p class="cu-page-loader__text">Loading</p>
        </div>
    </div>

    <div class="cu-ambiance" aria-hidden="true">
        <div class="cu-ambiance__aurora"></div>
        <div class="cu-ambiance__grid"></div>
        <div class="cu-ambiance__hex"></div>
        <div class="cu-ambiance__orb cu-ambiance__orb--1"></div>
        <div class="cu-ambiance__orb cu-ambiance__orb--2"></div>
        <div class="cu-ambiance__orb cu-ambiance__orb--3"></div>
        <div class="cu-ambiance__beams"></div>
        <canvas id="cu-neural-canvas"></canvas>
    </div>

    <div class="cu-shell">
        @include('layouts.admin.partials.panel-sidebar')
        <div class="cu-sidebar-overlay" id="cuSidebarOverlay" aria-hidden="true"></div>

        <div class="cu-main">
            @include('layouts.admin.partials.panel-header')

            <main class="cu-content">
                @yield('content')
            </main>

            <footer class="cu-footer">
                © {{ date('Y') }} ChirpUp Admin
            </footer>
        </div>
    </div>

    <script src="{{ asset('assets/admin/js/sweet-alert/sweetalert.min.js') }}"></script>
    <script src="{{ asset('assets/admin/js/admin-motion.js') }}"></script>
    @stack('scripts')
    <script>
      (function () {
        var loader = document.getElementById('cuPageLoader');

        function showLoader() {
          if (!loader) return;
          loader.classList.add('is-visible');
          loader.setAttribute('aria-busy', 'true');
        }

        function hideLoader() {
          if (!loader) return;
          loader.classList.remove('is-visible');
          loader.setAttribute('aria-busy', 'false');
        }

        window.cuShowLoader = showLoader;
        window.cuHideLoader = hideLoader;

        window.addEventListener('load', hideLoader);
        window.addEventListener('pageshow', function (event) {
          if (event.persisted) {
            hideLoader();
          }
        });

        document.addEventListener('click', function (event) {
          var link = event.target.closest('a[href]');
          if (!link) return;
          if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
            return;
          }

          var href = link.getAttribute('href');
          if (!href || href.charAt(0) === '#' || href.indexOf('javascript:') === 0) {
            return;
          }
          if (link.target && link.target !== '_self') {
            return;
          }
          if (link.hasAttribute('download')) {
            return;
          }

          try {
            var url = new URL(link.href, window.location.origin);
            if (url.origin !== window.location.origin) {
              return;
            }
          } catch (error) {
            return;
          }

          showLoader();
        });

        document.addEventListener('submit', function (event) {
          var form = event.target.closest('form');
          if (!form) return;

          if (form.classList.contains('cu-delete-form') && form.dataset.confirmed !== '1') {
            return;
          }

          showLoader();
        });

        var sidebar = document.getElementById('cuSidebar');
        var overlay = document.getElementById('cuSidebarOverlay');
        var menuToggle = document.getElementById('cuMenuToggle');
        var sidebarClose = document.getElementById('cuSidebarClose');
        var mobileQuery = window.matchMedia('(max-width: 991.98px)');

        function openSidebar() {
          document.body.classList.add('cu-sidebar-open');
          if (menuToggle) menuToggle.setAttribute('aria-expanded', 'true');
        }

        function closeSidebar() {
          document.body.classList.remove('cu-sidebar-open');
          if (menuToggle) menuToggle.setAttribute('aria-expanded', 'false');
        }

        if (menuToggle) {
          menuToggle.addEventListener('click', function () {
            if (document.body.classList.contains('cu-sidebar-open')) {
              closeSidebar();
            } else {
              openSidebar();
            }
          });
        }
        if (sidebarClose) sidebarClose.addEventListener('click', closeSidebar);
        if (overlay) overlay.addEventListener('click', closeSidebar);

        if (sidebar) {
          sidebar.addEventListener('click', function (event) {
            if (mobileQuery.matches && event.target.closest('a[href]:not([href="#"])')) {
              closeSidebar();
            }
          });
        }

        document.addEventListener('keydown', function (event) {
          if (event.key === 'Escape' && document.body.classList.contains('cu-sidebar-open')) {
            closeSidebar();
          }
        });

        var onBreakpointChange = function (event) {
          if (!event.matches) closeSidebar();
        };
        if (mobileQuery.addEventListener) {
          mobileQuery.addEventListener('change', onBreakpointChange);
        } else if (mobileQuery.addListener) {
          mobileQuery.addListener(onBreakpointChange);
        }

        document.querySelectorAll('.cu-nav__toggle').forEach(function (btn) {
          btn.addEventListener('click', function () {
            var item = btn.closest('.cu-nav__item');
            var panel = item ? item.querySelector('.cu-nav__children') : null;
            if (!item || !panel) return;

            var willOpen = panel.hasAttribute('hidden');
            panel.hidden = !willOpen;
            item.classList.toggle('is-open', willOpen);
            btn.setAttribute('aria-expanded', willOpen ? 'true' : 'false');
          });
        });

        document.addEventListener('submit', function (event) {
          var form = event.target.closest('form.cu-delete-form');
          if (!form || form.dataset.confirmed === '1') {
            return;
          }

          event.preventDefault();

          Swal.fire({
            title: 'Are you sure?',
            text: form.getAttribute('data-confirm') || 'Delete this item?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3d7eb8',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it',
            cancelButtonText: 'Cancel',
          }).then(function (result) {
            if (result.isConfirmed) {
              form.dataset.confirmed = '1';
              showLoader();
              form.submit();
            }
          });
        });

        @if (session('success'))
          Swal.fire({
            icon: 'success',
            title: 'Success',
            text: @json(session('success')),
            timer: 2500,
            showConfirmButton: false,
          });
        @endif

        @if (session('error'))
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: @json(session('error')),
          });
        @endif
      })();
    </script>
</body>
</html>
