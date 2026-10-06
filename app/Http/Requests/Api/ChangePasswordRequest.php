<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class ChangePasswordRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'current_password' => ['required', 'string'],
            'password' => ['required', 'string', 'min:8', 'different:current_password'],
            'confirm_password' => ['required', 'string', 'same:password'],
        ];
    }

    public function messages(): array
    {
        return [
            'confirm_password.same' => 'The confirm password must match the password.',
            'password.different' => 'The new password must be different from the current password.',
        ];
    }
}
