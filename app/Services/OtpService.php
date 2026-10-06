<?php

namespace App\Services;

use App\Mail\SendOtpMail;
use App\Models\EmailOtp;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;

class OtpService
{
    public function generateAndSend(string $email, string $purpose = 'verify'): void
    {
        $otp = (string) random_int(100000, 999999);

        EmailOtp::query()->where('email', $email)->delete();

        EmailOtp::query()->create([
            'email' => $email,
            'otp' => Hash::make($otp),
            'expires_at' => now()->addMinutes(10),
        ]);

        Mail::to($email)->send(new SendOtpMail($otp, $purpose));
    }

    public function verify(string $email, string $otp): void
    {
        $record = EmailOtp::query()
            ->where('email', $email)
            ->latest()
            ->first();

        if (! $record || $record->expires_at->isPast()) {
            throw ValidationException::withMessages([
                'otp' => 'The OTP is invalid or has expired.',
            ]);
        }

        if (! Hash::check($otp, $record->otp)) {
            throw ValidationException::withMessages([
                'otp' => 'The OTP is invalid or has expired.',
            ]);
        }

        EmailOtp::query()->where('email', $email)->delete();
    }
}
