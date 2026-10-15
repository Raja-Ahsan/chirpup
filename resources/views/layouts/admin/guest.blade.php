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
            --cu-ink: #f3f7fb;
            --cu-muted: #b7c7d8;
            --cu-line: rgba(180, 205, 230, 0.28);
            --cu-blue: #4f9fe0;
            --cu-blue-deep: #2f7fbf;
            --cu-blue-soft: #6eb6ef;
            --cu-card: rgba(12, 28, 48, 0.72);
            --font-display: "Sora", sans-serif;
            --font-body: "Manrope", sans-serif;
        }

        * { box-sizing: border-box; }
        html, body { margin: 0; min-height: 100%; }
        body {
            font-family: var(--font-body);
            color: var(--cu-ink);
            background: #0e2848;
        }

        .auth-shell {
            position: relative;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(340px, 460px);
            align-items: stretch;
            overflow: hidden;
            background:
                linear-gradient(90deg, rgba(8, 24, 44, 0.12) 0%, rgba(8, 24, 44, 0.18) 48%, rgba(8, 24, 44, 0.62) 72%, rgba(8, 24, 44, 0.78) 100%),
                url("{{ asset('assets/admin/images/brand/login-background.png') }}") center / cover no-repeat;
            animation: authBgDrift 26s ease-in-out infinite alternate;
        }

        .auth-shell__fx {
            position: absolute;
            inset: 0;
            pointer-events: none;
            z-index: 1;
            overflow: hidden;
        }

        .auth-shell__spark {
            position: absolute;
            width: 0.65rem;
            height: 0.65rem;
            border-radius: 50%;
            background: radial-gradient(circle, #ffffff 0%, #ffe98a 42%, #f0c94a 72%, transparent 100%);
            box-shadow: 0 0 12px rgba(255, 233, 138, 0.85);
            animation: authSparkle 3.4s ease-in-out infinite;
            opacity: 0;
        }

        .auth-shell__spark:nth-child(1) { left: 12%; top: 16%; animation-delay: 0s; }
        .auth-shell__spark:nth-child(2) { left: 28%; top: 28%; animation-delay: 0.7s; width: 0.45rem; height: 0.45rem; }
        .auth-shell__spark:nth-child(3) { left: 48%; top: 14%; animation-delay: 1.3s; }
        .auth-shell__spark:nth-child(4) { left: 18%; top: 48%; animation-delay: 1.9s; width: 0.4rem; height: 0.4rem; }
        .auth-shell__spark:nth-child(5) { left: 62%; top: 22%; animation-delay: 2.4s; width: 0.5rem; height: 0.5rem; }
        .auth-shell__spark:nth-child(6) { left: 38%; top: 58%; animation-delay: 0.4s; }

        .auth-shell__bubble {
            position: absolute;
            bottom: -3rem;
            border-radius: 50%;
            border: 2px solid rgba(255, 255, 255, 0.72);
            background:
                radial-gradient(circle at 30% 28%, rgba(255, 255, 255, 0.95) 0%, rgba(255, 255, 255, 0.32) 22%, rgba(120, 190, 255, 0.26) 55%, rgba(61, 126, 184, 0.16) 100%);
            box-shadow:
                inset 0 -6px 12px rgba(47, 101, 153, 0.16),
                0 4px 14px rgba(255, 255, 255, 0.2);
            animation: authBubbleRise linear infinite;
            opacity: 0;
        }

        .auth-shell__bubble::before {
            content: "";
            position: absolute;
            top: 16%;
            left: 20%;
            width: 28%;
            height: 22%;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.95);
        }

        .auth-shell__bubble:nth-child(7) { left: 8%; width: 2rem; height: 2rem; animation-duration: 9s; animation-delay: 0s; }
        .auth-shell__bubble:nth-child(8) { left: 22%; width: 1.3rem; height: 1.3rem; animation-duration: 11s; animation-delay: 1.5s; }
        .auth-shell__bubble:nth-child(9) { left: 40%; width: 2.4rem; height: 2.4rem; animation-duration: 10s; animation-delay: 0.8s; }
        .auth-shell__bubble:nth-child(10) { left: 55%; width: 1.6rem; height: 1.6rem; animation-duration: 12s; animation-delay: 2.6s; }

        .auth-visual {
            position: relative;
            z-index: 2;
            min-height: 100vh;
            display: grid;
            place-items: end center;
            padding: 2rem 1rem 0;
            background: transparent;
        }

        .auth-visual__prince {
            width: min(68%, 420px);
            max-height: 90vh;
            height: auto;
            object-fit: contain;
            display: block;
            filter: drop-shadow(0 18px 28px rgba(0, 0, 0, 0.35));
            animation: authPrinceBob 4.5s ease-in-out infinite;
            transform-origin: center bottom;
        }

        .auth-form-side {
            position: relative;
            z-index: 3;
            display: grid;
            place-items: center;
            padding: 2rem 1.5rem;
            background: transparent;
        }

        .auth-card {
            position: relative;
            width: min(100%, 26rem);
            background: var(--cu-card);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid rgba(180, 205, 230, 0.22);
            border-radius: 1.35rem;
            box-shadow:
                0 24px 60px rgba(0, 0, 0, 0.35),
                0 1px 0 rgba(255, 255, 255, 0.08) inset;
            padding: 2.15rem 1.9rem 1.85rem;
            opacity: 1;
            animation: fadeUp 0.55s ease both;
        }

        .auth-brand {
            display: flex;
            justify-content: center;
            margin-bottom: 0.9rem;
        }

        .auth-brand img {
            width: 7.5rem;
            height: auto;
            display: block;
            animation: authLogoPop 0.7s ease both, authLogoFloat 5s ease-in-out 0.7s infinite;
        }

        .auth-form .auth-field,
        .auth-form .auth-remember,
        .auth-form .auth-submit {
            animation: fadeUp 0.5s ease both;
        }

        .auth-form .auth-field:nth-child(1) { animation-delay: 0.12s; }
        .auth-form .auth-field:nth-child(2) { animation-delay: 0.22s; }
        .auth-form .auth-remember { animation-delay: 0.32s; }
        .auth-form .auth-submit { animation-delay: 0.4s; }

        .auth-copy {
            text-align: center;
            margin-bottom: 1.45rem;
        }

        .auth-copy h1 {
            margin: 0 0 0.35rem;
            font-family: var(--font-display);
            font-size: 1.45rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #f7fbff;
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
            color: #dce8f4;
        }

        .auth-field input[type="email"],
        .auth-field input[type="password"],
        .auth-field input[type="text"] {
            width: 100%;
            border: 1px solid var(--cu-line);
            background: rgba(8, 28, 52, 0.7);
            color: #f2f7fc;
            border-radius: 0.8rem;
            padding: 0.9rem 1rem;
            font: inherit;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .auth-field input::placeholder { color: #8ea5bc; }

        .auth-field input:focus {
            border-color: var(--cu-blue);
            background: rgba(8, 28, 52, 0.9);
            box-shadow: 0 0 0 4px rgba(79, 159, 224, 0.2);
        }

        .auth-field input.is-invalid {
            border-color: #e06b6b;
            box-shadow: 0 0 0 3px rgba(224, 107, 107, 0.18);
        }

        .auth-password { position: relative; }
        .auth-password input { padding-right: 3.2rem; }

        .auth-toggle {
            position: absolute;
            top: 50%;
            right: 0.7rem;
            transform: translateY(-50%);
            border: 0;
            background: transparent;
            color: #9eb4ca;
            font-size: 0.78rem;
            font-weight: 600;
            cursor: pointer;
        }

        .auth-toggle:hover { color: #d7e8f8; }

        .auth-error {
            margin-top: 0.4rem;
            color: #ff8f8f;
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
            position: relative;
            overflow: hidden;
            width: 100%;
            border: 0;
            border-radius: 0.85rem;
            padding: 1rem;
            background:
                linear-gradient(120deg, rgba(255, 255, 255, 0.18), transparent 42%),
                linear-gradient(180deg, #5eb4ef 0%, #3d8fd4 42%, #2f6fb0 100%);
            color: #fff;
            font-family: var(--font-display);
            font-size: 0.98rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow:
                0 12px 28px rgba(45, 120, 180, 0.42),
                0 0 0 1px rgba(245, 215, 110, 0.28) inset;
            transition: transform 0.15s ease, filter 0.2s ease, box-shadow 0.2s ease;
            animation: authBtnGlow 2.8s ease-in-out infinite;
        }

        .auth-submit::before {
            content: "";
            position: absolute;
            top: 0;
            left: -45%;
            width: 40%;
            height: 100%;
            background: linear-gradient(
                100deg,
                transparent 0%,
                rgba(255, 248, 200, 0.35) 48%,
                transparent 100%
            );
            transform: skewX(-18deg);
            animation: authBtnShine 3.4s ease-in-out infinite;
            pointer-events: none;
        }

        .auth-submit:hover {
            transform: translateY(-1px);
            filter: brightness(1.06);
            box-shadow:
                0 16px 32px rgba(45, 120, 180, 0.5),
                0 0 0 1px rgba(245, 215, 110, 0.4) inset;
        }

        .auth-foot {
            margin-top: 1.2rem;
            text-align: center;
            color: #8ea3b8;
            font-size: 0.78rem;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes authPrinceBob {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes authSparkle {
            0%, 100% { opacity: 0; transform: scale(0.45); }
            40%, 60% { opacity: 1; transform: scale(1.2); }
        }

        @keyframes authBubbleRise {
            0% { opacity: 0; transform: translateY(0) scale(0.85); }
            10% { opacity: 0.95; }
            75% { opacity: 0.7; }
            100% { opacity: 0; transform: translateY(-78vh) scale(1.15); }
        }

        @keyframes authBgDrift {
            0% { background-position: 50% 50%; }
            100% { background-position: 54% 46%; }
        }

        @keyframes authLogoPop {
            from { opacity: 0; transform: scale(0.86); }
            to { opacity: 1; transform: scale(1); }
        }

        @keyframes authLogoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-4px); }
        }

        @keyframes authBtnGlow {
            0%, 100% {
                box-shadow:
                    0 12px 28px rgba(45, 120, 180, 0.42),
                    0 0 0 1px rgba(245, 215, 110, 0.28) inset;
            }
            50% {
                box-shadow:
                    0 14px 34px rgba(45, 120, 180, 0.55),
                    0 0 18px rgba(94, 180, 239, 0.35),
                    0 0 0 1px rgba(245, 215, 110, 0.45) inset;
            }
        }

        @keyframes authBtnShine {
            0%, 35% { left: -45%; opacity: 0; }
            45% { opacity: 1; }
            65%, 100% { left: 120%; opacity: 0; }
        }

        @media (prefers-reduced-motion: reduce) {
            .auth-card,
            .auth-brand img,
            .auth-form .auth-field,
            .auth-form .auth-remember,
            .auth-form .auth-submit,
            .auth-submit::before,
            .auth-shell,
            .auth-visual__prince,
            .auth-shell__spark,
            .auth-shell__bubble {
                animation: none !important;
            }
        }

        @media (max-width: 900px) {
            .auth-shell {
                grid-template-columns: 1fr;
                background-position: 35% center;
            }

            .auth-visual {
                min-height: 34vh;
                padding-top: 1rem;
            }

            .auth-visual__prince {
                width: min(58%, 240px);
            }

            .auth-form-side {
                padding: 1.25rem 1.1rem 2rem;
            }

            .auth-shell {
                background-image:
                    linear-gradient(180deg, rgba(8, 24, 44, 0.2) 0%, rgba(8, 24, 44, 0.55) 42%, rgba(8, 24, 44, 0.82) 100%),
                    url("{{ asset('assets/admin/images/brand/login-background.png') }}");
                background-size: cover;
                background-repeat: no-repeat;
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
