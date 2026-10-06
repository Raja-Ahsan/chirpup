<div class="page-header">
  <div class="header-wrapper row m-0">
    <div class="header-logo-wrapper col-auto p-0">
      <div class="logo-wrapper">
        <a href="{{ route('admin.dashboard') }}"><img
            class="img-fluid"
            src="{{ asset('assets/admin/images/brand/chirpup-logo.png') }}"
            alt="ChirpUp"
            style="max-height: 42px; width: auto;" /></a>
      </div>
      <div class="toggle-sidebar">
        <i
          class="status_toggle middle sidebar-toggle"
          data-feather="align-center"></i>
      </div>
    </div>
    <div
      class="nav-right col-xxl-7 col-xl-6 col-md-7 col-8 pull-right right-header p-0 ms-auto">
      <ul class="nav-menus">
        <li>
          <div class="mode">
            <svg>
              <use href="{{ asset('assets/admin/svg/icon-sprite.svg#moon') }}"></use>
            </svg>
          </div>
        </li>
        <li class="profile-nav onhover-dropdown pe-0 py-0">
          <div class="d-flex profile-media">
            <img
              class="b-r-10"
              src="{{ asset('assets/admin/images/dashboard/profile.png') }}"
              alt="" />
            <div class="flex-grow-1">
              <span>{{ auth()->user()->name ?? 'Admin' }}</span>
              <p class="mb-0">
                {{ formatRole(auth()->user()->role ?? 'admin') }} <i class="middle fa-solid fa-angle-down"></i>
              </p>
            </div>
          </div>
          <ul class="profile-dropdown onhover-show-div">
            <li>
              <form method="POST" action="{{ route('admin.logout') }}">
                @csrf
                <button type="submit" class="btn btn-link p-0 border-0 text-decoration-none d-flex align-items-center gap-2">
                  <i data-feather="log-out"></i><span>Log out</span>
                </button>
              </form>
            </li>
          </ul>
        </li>
      </ul>
    </div>
    <script class="result-template" type="text/x-handlebars-template">
      <div class="ProfileCard u-cf">
              <div class="ProfileCard-avatar"><svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="feather feather-airplay m-0"
                ><path
                    d="M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1"
                  ></path><polygon
                    points="12 15 17 21 7 21 12 15"
                  ></polygon></svg></div>
              <div class="ProfileCard-details">
                <div class="ProfileCard-realName"></div>
              </div>
            </div>
          </script>
    <script class="empty-template" type="text/x-handlebars-template">
      <div class="EmptyMessage">Your search turned up 0 results. This most
              likely means the backend is down, yikes!</div>
          </script>
  </div>
</div>