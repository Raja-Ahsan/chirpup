<!DOCTYPE html>
<html lang="en">

<head>
    @include('layouts.admin.partials.head')
</head>

<body class="light" onload="startTime()">
    <div class="cu-ambiance" aria-hidden="true">
        <span class="cu-ambiance__sun"></span>
        <span class="cu-ambiance__ray cu-ambiance__ray--1"></span>
        <span class="cu-ambiance__ray cu-ambiance__ray--2"></span>
        <span class="cu-ambiance__ray cu-ambiance__ray--3"></span>
        <span class="cu-ambiance__ray cu-ambiance__ray--4"></span>
        <span class="cu-ambiance__star is-lg"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star is-lg"></span>
        <span class="cu-ambiance__star"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star"></span>
        <span class="cu-ambiance__star is-lg"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star"></span>
        <span class="cu-ambiance__star is-lg"></span>
        <span class="cu-ambiance__star is-sm"></span>
        <span class="cu-ambiance__star"></span>
    </div>
    <div class="loader-wrapper">
        <div class="loader-index"><span></span></div>
        <svg>
            <defs></defs>
            <filter id="goo">
                <fegaussianblur
                    in="SourceGraphic"
                    stddeviation="11"
                    result="blur"></fegaussianblur>
                <fecolormatrix
                    in="blur"
                    values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 19 -9"
                    result="goo"></fecolormatrix>
            </filter>
        </svg>
    </div>
    <div class="tap-top"><i data-feather="chevrons-up"></i></div>
    <div class="page-wrapper compact-wrapper" id="pageWrapper">
        @include('layouts.admin.partials.header')
        <div class="page-body-wrapper">
            @include('layouts.admin.partials.sidebar')
            <div class="page-body">
                <div class="container-fluid">
                    @include('layouts.admin.partials.bread_crumbs')
                    @yield('content')
                </div>
            </div>
            @include('layouts.admin.partials.footer')
        </div>
    </div>
    @include('layouts.admin.partials.scripts')
    <script>
      localStorage.setItem('mode-cuba', 'light');
      document.body.classList.remove('dark-only');
      document.body.classList.add('light');
      document.querySelectorAll('.mode').forEach(function (el) {
        el.classList.remove('active');
      });
    </script>
</body>

</html>