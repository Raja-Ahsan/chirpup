<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="csrf-token" content="{{ csrf_token() }}" />
    <title>@yield('title', 'Admin Login') — ChirpUp</title>
    <link rel="icon" href="{{ asset('assets/admin/images/favicon.png') }}" type="image/x-icon" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&family=Sora:wght@500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --cu-ink: #1b2430;
            --cu-muted: #667685;
            --cu-line: #cfdced;
            --cu-blue: #3d7eb8;
            --cu-blue-deep: #2f6599;
            --cu-blue-soft: #5ea8e0;
            --font-display: "Sora", sans-serif;
            --font-body: "Manrope", sans-serif;
        }

        * { box-sizing: border-box; }
        html, body { margin: 0; min-height: 100%; }
        body {
            font-family: var(--font-body);
            color: var(--cu-ink);
            background: #ffffff;
        }

        .auth-shell {
            position: relative;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1.05fr) minmax(320px, 460px);
            align-items: stretch;
            overflow: hidden;
        }

        .auth-visual {
            position: relative;
            min-height: 100vh;
            background:
                linear-gradient(180deg, #5ea8e0 0%, #3d7eb8 28%, #0a0a0a 55%, #000000 100%);
            display: grid;
            place-items: end center;
            padding: 2rem 1rem 0;
            overflow: hidden;
        }

        .auth-visual__prince {
            width: min(72%, 380px);
            max-height: 88vh;
            height: auto;
            object-fit: contain;
            display: block;
            position: relative;
            z-index: 1;
            filter: drop-shadow(0 18px 28px rgba(0, 0, 0, 0.35));
        }

        .auth-form-side {
            position: relative;
            display: grid;
            place-items: center;
            padding: 2rem 1.5rem;
            background:
                radial-gradient(circle at 85% 10%, rgba(59, 110, 245, 0.08), transparent 34%),
                linear-gradient(180deg, #ffffff 0%, #f7faff 100%);
        }

        .auth-card {
            width: min(100%, 24rem);
            background: #fff;
            border: 1px solid rgba(207, 220, 237, 0.95);
            border-radius: 1rem;
            box-shadow: 0 18px 45px rgba(40, 80, 160, 0.08);
            padding: 2rem 1.75rem 1.7rem;
            animation: fadeUp 0.55s ease both;
        }

        .auth-brand {
            display: flex;
            justify-content: center;
            margin-bottom: 0.85rem;
        }

        .auth-brand img {
            width: 7.5rem;
            height: auto;
            display: block;
        }

        .auth-copy {
            text-align: center;
            margin-bottom: 1.4rem;
        }

        .auth-copy h1 {
            margin: 0 0 0.3rem;
            font-family: var(--font-display);
            font-size: 1.35rem;
            font-weight: 700;
            letter-spacing: -0.02em;
        }

        .auth-copy p {
            margin: 0;
            color: var(--cu-muted);
            font-size: 0.92rem;
        }

        .auth-form { display: grid; gap: 1rem; }

        .auth-field label {
            display: block;
            margin-bottom: 0.4rem;
            font-size: 0.84rem;
            font-weight: 600;
        }

        .auth-field input[type="email"],
        .auth-field input[type="password"],
        .auth-field input[type="text"] {
            width: 100%;
            border: 1px solid var(--cu-line);
            background: #fff;
            color: var(--cu-ink);
            border-radius: 0.7rem;
            padding: 0.85rem 0.95rem;
            font: inherit;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .auth-field input:focus {
            border-color: var(--cu-blue);
            box-shadow: 0 0 0 4px rgba(59, 110, 245, 0.14);
        }

        .auth-field input.is-invalid {
            border-color: #d64545;
            box-shadow: 0 0 0 3px rgba(214, 69, 69, 0.12);
        }

        .auth-password { position: relative; }
        .auth-password input { padding-right: 3rem; }

        .auth-toggle {
            position: absolute;
            top: 50%;
            right: 0.65rem;
            transform: translateY(-50%);
            border: 0;
            background: transparent;
            color: var(--cu-muted);
            font-size: 0.78rem;
            font-weight: 600;
            cursor: pointer;
        }

        .auth-error {
            margin-top: 0.4rem;
            color: #c03535;
            font-size: 0.82rem;
            font-weight: 500;
        }

        .auth-error[hidden] { display: none !important; }

        .auth-remember {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            color: var(--cu-muted);
            font-size: 0.88rem;
            cursor: pointer;
        }

        .auth-remember input {
            width: 1rem;
            height: 1rem;
            accent-color: var(--cu-blue);
        }

        .auth-submit {
            width: 100%;
            border: 0;
            border-radius: 0.75rem;
            padding: 0.95rem 1rem;
            background: linear-gradient(180deg, var(--cu-blue-soft) 0%, var(--cu-blue) 55%, var(--cu-blue-deep) 100%);
            color: #fff;
            font-family: var(--font-display);
            font-size: 0.98rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 10px 22px rgba(61, 126, 184, 0.32);
            transition: transform 0.15s ease, filter 0.2s ease;
        }

        .auth-submit:hover {
            transform: translateY(-1px);
            filter: brightness(1.04);
        }

        .auth-foot {
            margin-top: 1.1rem;
            text-align: center;
            color: #8a97a5;
            font-size: 0.78rem;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (prefers-reduced-motion: reduce) {
            .auth-card {
                animation: none !important;
            }
        }

        @media (max-width: 900px) {
            .auth-shell {
                grid-template-columns: 1fr;
            }

            .auth-visual {
                min-height: 38vh;
                padding-top: 1rem;
            }

            .auth-visual__prince {
                width: min(58%, 240px);
            }

            .auth-form-side {
                padding: 1.5rem 1.1rem 2rem;
            }
        }
    </style>
    @stack('styles')
</head>
<body>
    @yield('content')
    @stack('scripts')
</body>
</html>
