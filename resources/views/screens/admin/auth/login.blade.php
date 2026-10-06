@extends('layouts.admin.guest')

@section('title', 'Admin Login')

@section('content')
    <div class="auth-shell">
        <aside class="auth-visual" aria-hidden="true">
            <img
                class="auth-visual__prince"
                src="{{ asset('assets/admin/images/brand/chirpup-prince.gif') }}"
                alt="" />
        </aside>

        <section class="auth-form-side">
            <div class="auth-card">
                <a class="auth-brand" href="{{ route('admin.login') }}">
                    <img
                        src="{{ asset('assets/admin/images/brand/chirpup-logo.png') }}"
                        alt="ChirpUp" />
                </a>

                <div class="auth-copy">
                    <h1>ChirpUp</h1>
                    <p>Sign in to your admin workspace.</p>
                </div>

                <form
                    class="auth-form"
                    id="adminLoginForm"
                    method="POST"
                    action="{{ route('admin.login.submit') }}"
                    novalidate>
                    @csrf

                    <div class="auth-field">
                        <label for="email">Email</label>
                        <input
                            id="email"
                            type="email"
                            name="email"
                            value="{{ old('email') }}"
                            class="{{ $errors->has('email') ? 'is-invalid' : '' }}"
                            autofocus
                            autocomplete="username"
                            placeholder="your@email.com" />
                        <div class="auth-error" id="emailError" @if(!$errors->has('email')) hidden @endif>
                            {{ $errors->first('email') }}
                        </div>
                    </div>

                    <div class="auth-field">
                        <label for="password">Password</label>
                        <div class="auth-password">
                            <input
                                id="password"
                                type="password"
                                name="password"
                                class="{{ $errors->has('password') ? 'is-invalid' : '' }}"
                                autocomplete="current-password"
                                placeholder="Enter your password" />
                            <button type="button" class="auth-toggle" id="togglePassword" aria-label="Show password">Show</button>
                        </div>
                        <div class="auth-error" id="passwordError" @if(!$errors->has('password')) hidden @endif>
                            {{ $errors->first('password') }}
                        </div>
                    </div>

                    <label class="auth-remember" for="remember">
                        <input id="remember" type="checkbox" name="remember" {{ old('remember') ? 'checked' : '' }} />
                        Remember me
                    </label>

                    <button class="auth-submit" type="submit">Sign in</button>
                </form>

                <p class="auth-foot">Secure admin access for ChirpUp</p>
            </div>
        </section>
    </div>
@endsection

@push('scripts')
    <script>
        (function () {
            var toggle = document.getElementById('togglePassword');
            var passwordInput = document.getElementById('password');
            var emailInput = document.getElementById('email');
            var form = document.getElementById('adminLoginForm');
            var emailError = document.getElementById('emailError');
            var passwordError = document.getElementById('passwordError');

            function setError(input, errorEl, message) {
                if (message) {
                    input.classList.add('is-invalid');
                    errorEl.textContent = message;
                    errorEl.hidden = false;
                } else {
                    input.classList.remove('is-invalid');
                    errorEl.textContent = '';
                    errorEl.hidden = true;
                }
            }

            function validateEmail() {
                var value = (emailInput.value || '').trim();
                if (!value) {
                    setError(emailInput, emailError, 'Please enter your email address.');
                    return false;
                }
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    setError(emailInput, emailError, 'Please enter a valid email address.');
                    return false;
                }
                setError(emailInput, emailError, '');
                return true;
            }

            function validatePassword() {
                var value = passwordInput.value || '';
                if (!value) {
                    setError(passwordInput, passwordError, 'Please enter your password.');
                    return false;
                }
                setError(passwordInput, passwordError, '');
                return true;
            }

            if (toggle && passwordInput) {
                toggle.addEventListener('click', function () {
                    var isHidden = passwordInput.type === 'password';
                    passwordInput.type = isHidden ? 'text' : 'password';
                    toggle.textContent = isHidden ? 'Hide' : 'Show';
                    toggle.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');
                });
            }

            if (emailInput) {
                emailInput.addEventListener('input', function () {
                    if (!emailError.hidden) validateEmail();
                });
            }

            if (passwordInput) {
                passwordInput.addEventListener('input', function () {
                    if (!passwordError.hidden) validatePassword();
                });
            }

            if (form) {
                form.addEventListener('submit', function (event) {
                    var emailOk = validateEmail();
                    var passwordOk = validatePassword();
                    if (!emailOk || !passwordOk) {
                        event.preventDefault();
                        (!emailOk ? emailInput : passwordInput).focus();
                    }
                });
            }
        })();
    </script>
@endpush
