@php
    $isReset = ($purpose ?? 'verify') === 'reset';
    $title = $isReset ? 'Reset your password' : 'Verify your email';
    $intro = $isReset
        ? 'Use this one-time password to reset your ChirpUp account password.'
        : 'Use this one-time password to verify your ChirpUp account.';
    $digits = str_split((string) $otp);
@endphp
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{{ $title }} — ChirpUp</title>
</head>
<body style="margin:0;padding:0;background-color:#eef3f8;font-family:Arial,Helvetica,sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#eef3f8" style="background-color:#eef3f8;margin:0;padding:0;">
        <tr>
            <td align="center" style="padding:32px 16px;">
                <table role="presentation" width="560" cellpadding="0" cellspacing="0" border="0" style="width:100%;max-width:560px;background-color:#ffffff;border-radius:16px;overflow:hidden;">
                    {{-- Brand header --}}
                    <tr>
                        <td align="center" bgcolor="#3d7eb8" style="background-color:#3d7eb8;background-image:linear-gradient(180deg,#5ea8e0 0%,#3d7eb8 100%);padding:28px 24px 24px;">
                            <img
                                src="{{ $message->embed(public_path('assets/admin/images/brand/chirpup-logo.png')) }}"
                                alt="ChirpUp"
                                width="150"
                                style="display:block;width:150px;max-width:60%;height:auto;margin:0 auto;border:0;"
                            >
                        </td>
                    </tr>

                    {{-- Body --}}
                    <tr>
                        <td style="padding:36px 32px 28px;color:#1b2430;">
                            <p style="margin:0 0 8px;font-size:12px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#3d7eb8;">
                                ChirpUp security
                            </p>
                            <h1 style="margin:0 0 12px;font-size:26px;line-height:1.25;font-weight:700;color:#102033;">
                                {{ $title }}
                            </h1>
                            <p style="margin:0 0 28px;font-size:15px;line-height:1.6;color:#4a5568;">
                                {{ $intro }}
                            </p>

                            {{-- OTP digits --}}
                            <table role="presentation" cellpadding="0" cellspacing="0" border="0" align="center" style="margin:0 auto 18px;">
                                <tr>
                                    @foreach ($digits as $digit)
                                        <td align="center" valign="middle" width="48" height="56" bgcolor="#f3f8fc" style="width:48px;height:56px;background-color:#f3f8fc;border:1px solid #c5daf0;border-radius:10px;font-size:24px;font-weight:700;color:#102033;padding:0 2px;">
                                            {{ $digit }}
                                        </td>
                                        @if (! $loop->last)
                                            <td width="8" style="width:8px;font-size:0;line-height:0;">&nbsp;</td>
                                        @endif
                                    @endforeach
                                </tr>
                            </table>

                            <p style="margin:0 0 24px;text-align:center;font-size:13px;line-height:1.5;color:#6b7a8d;">
                                Or enter this code:
                                <strong style="display:inline-block;margin-left:4px;font-size:16px;letter-spacing:3px;color:#102033;">{{ $otp }}</strong>
                            </p>

                            <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin:0 0 24px;">
                                <tr>
                                    <td bgcolor="#f7fbfe" style="background-color:#f7fbfe;border:1px solid #d7e7f5;border-radius:12px;padding:14px 16px;">
                                        <p style="margin:0;font-size:13px;line-height:1.5;color:#3d7eb8;text-align:center;">
                                            This code expires in <strong>10 minutes</strong>.
                                        </p>
                                    </td>
                                </tr>
                            </table>

                            <p style="margin:0;font-size:13px;line-height:1.6;color:#6b7a8d;text-align:center;">
                                If you did not request this, you can safely ignore this email.
                            </p>
                        </td>
                    </tr>

                    {{-- Footer --}}
                    <tr>
                        <td bgcolor="#f5f8fb" style="background-color:#f5f8fb;border-top:1px solid #e4edf5;padding:18px 24px;text-align:center;">
                            <p style="margin:0 0 4px;font-size:12px;color:#7a8a9c;">
                                &copy; {{ date('Y') }} ChirpUp. All rights reserved.
                            </p>
                            <p style="margin:0;font-size:12px;color:#9aa8b8;">
                                This is an automated message &mdash; please do not reply.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
