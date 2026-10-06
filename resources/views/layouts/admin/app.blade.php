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
    <link rel="stylesheet" href="{{ asset('assets/admin/css/chirpup-panel.css') }}" />
    @stack('styles')
</head>
<body class="cu-panel">
    <div class="cu-ambiance" aria-hidden="true">
        <div class="cu-ambiance__dots"></div>
        <div class="cu-ambiance__glow"></div>
        <img
            class="cu-ambiance__character"
            src="{{ asset('assets/admin/images/brand/chirpup-characters-bg.png') }}"
            alt="" />
        <div class="cu-ambiance__hex"></div>
        <div class="cu-ambiance__hex cu-ambiance__hex--2"></div>
        <div class="cu-ambiance__beam cu-ambiance__beam--1"></div>
        <div class="cu-ambiance__beam cu-ambiance__beam--2"></div>
        <div class="cu-ambiance__beam cu-ambiance__beam--3"></div>
    </div>

    <div class="cu-shell">
        @include('layouts.admin.partials.panel-sidebar')

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

    @stack('scripts')
    <script>
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
    </script>
</body>
</html>
