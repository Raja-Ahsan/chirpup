<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ResendOtpRequest;
use App\Http\Requests\Api\VerifyOtpRequest;
use App\Models\User;
use App\Services\OtpService;
use Illuminate\Http\JsonResponse;

class OtpController extends Controller
{
    public function __construct(private readonly OtpService $otpService)
    {
    }

    public function verify(VerifyOtpRequest $request): JsonResponse
    {
        $email = $request->string('email')->toString();
        $user = User::query()->where('email', $email)->firstOrFail();

        if ($user->email_verified_at) {
            return response()->json([
                'success' => true,
                'message' => 'Email is already verified.',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'role' => $user->role,
                        'email_verified_at' => $user->email_verified_at,
                    ],
                ],
            ]);
        }

        $this->otpService->verify($email, $request->string('otp')->toString());

        $user->forceFill([
            'email_verified_at' => now(),
        ])->save();

        return response()->json([
            'success' => true,
            'message' => 'Email verified successfully. You can now log in.',
            'data' => [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'email_verified_at' => $user->email_verified_at,
                ],
            ],
        ]);
    }

    public function resend(ResendOtpRequest $request): JsonResponse
    {
        $email = $request->string('email')->toString();
        $user = User::query()->where('email', $email)->firstOrFail();

        if ($user->email_verified_at) {
            return response()->json([
                'success' => false,
                'message' => 'Email is already verified.',
                'data' => null,
            ], 422);
        }

        $this->otpService->generateAndSend($email, 'verify');

        return response()->json([
            'success' => true,
            'message' => 'A new OTP has been sent to your email.',
            'data' => null,
        ]);
    }
}
