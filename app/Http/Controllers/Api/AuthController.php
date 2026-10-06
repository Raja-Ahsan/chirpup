<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ChangePasswordRequest;
use App\Http\Requests\Api\ForgotPasswordRequest;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\ParentPinRequest;
use App\Http\Requests\Api\RegisterRequest;
use App\Http\Requests\Api\ResetPasswordRequest;
use App\Http\Requests\Api\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\OtpService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function __construct(private readonly OtpService $otpService)
    {
    }

    public function register(RegisterRequest $request): JsonResponse
    {
        $user = User::query()->create([
            'name' => $request->string('name')->toString(),
            'email' => $request->string('email')->toString(),
            'password' => $request->string('password')->toString(),
            'role' => config('roles.user'),
        ]);

        $this->otpService->generateAndSend($user->email, 'verify');

        return response()->json([
            'success' => true,
            'message' => 'Registration successful. Please verify the OTP sent to your email.',
            'data' => [
                'user' => $this->userPayload($user),
            ],
        ], 201);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $user = User::query()->where('email', $request->string('email')->toString())->first();

        if (! $user || ! Hash::check($request->string('password')->toString(), $user->password)) {
            throw ValidationException::withMessages([
                'email' => 'These credentials do not match our records.',
            ]);
        }

        if (! $user->email_verified_at) {
            return response()->json([
                'success' => false,
                'message' => 'Please verify your email with the OTP before logging in.',
                'data' => null,
            ], 403);
        }

        $token = $user->createToken('api')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful.',
            'data' => [
                'token' => $token,
                'token_type' => 'Bearer',
                'user' => $this->userPayload($user),
            ],
        ]);
    }

    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        $email = $request->string('email')->toString();

        $this->otpService->generateAndSend($email, 'reset');

        return response()->json([
            'success' => true,
            'message' => 'A password reset OTP has been sent to your email.',
            'data' => null,
        ]);
    }

    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        $email = $request->string('email')->toString();

        $this->otpService->verify($email, $request->string('otp')->toString());

        $user = User::query()->where('email', $email)->firstOrFail();
        $user->forceFill([
            'password' => $request->string('password')->toString(),
        ])->save();

        $user->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Password reset successfully. Please log in with your new password.',
            'data' => null,
        ]);
    }

    public function changePassword(ChangePasswordRequest $request): JsonResponse
    {
        $user = $request->user();

        if (! Hash::check($request->string('current_password')->toString(), $user->password)) {
            throw ValidationException::withMessages([
                'current_password' => 'The current password is incorrect.',
            ]);
        }

        $user->forceFill([
            'password' => $request->string('password')->toString(),
        ])->save();

        $user->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Password changed successfully. Please log in again.',
            'data' => null,
        ]);
    }

    public function updateProfile(UpdateProfileRequest $request): JsonResponse
    {
        $user = $request->user();
        $email = $request->string('email')->toString();
        $emailChanged = strcasecmp($user->email, $email) !== 0;

        $user->fill([
            'name' => $request->string('name')->toString(),
            'email' => $email,
        ]);

        if ($emailChanged) {
            $user->email_verified_at = null;
        }

        $user->save();

        if ($emailChanged) {
            $this->otpService->generateAndSend($user->email, 'verify');
        }

        return response()->json([
            'success' => true,
            'message' => $emailChanged
                ? 'Profile updated. Please verify the OTP sent to your new email.'
                : 'Profile updated successfully.',
            'data' => [
                'user' => $this->userPayload($user->fresh()),
                'email_verification_required' => $emailChanged,
            ],
        ]);
    }

    public function parentPin(ParentPinRequest $request): JsonResponse
    {
        $user = $request->user();

        $user->forceFill([
            'user_pin' => $request->string('user_pin')->toString(),
        ])->save();

        return response()->json([
            'success' => true,
            'message' => 'Parent pin updated successfully.',
            'data' => [
                'user' => $this->userPayload($user->fresh()),
            ],
        ]);
    }

    public function verifyParentPin(ParentPinRequest $request): JsonResponse
    {
        $user = $request->user();

        if (! filled($user->user_pin)) {
            return response()->json([
                'success' => false,
                'message' => 'Parent pin has not been set yet.',
                'data' => null,
            ], 422);
        }

        if (! Hash::check($request->string('user_pin')->toString(), $user->user_pin)) {
            throw ValidationException::withMessages([
                'user_pin' => 'The parent pin is incorrect.',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Parent pin verified successfully.',
            'data' => [
                'verified' => true,
            ],
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully.',
            'data' => null,
        ]);
    }

    public function user(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'User fetched successfully.',
            'data' => [
                'user' => $this->userPayload($request->user()),
            ],
        ]);
    }

    private function userPayload(User $user): array
    {
        $user->loadMissing(['children.year', 'children.character', 'children.todayMood']);

        return (new UserResource($user))->resolve();
    }
}
