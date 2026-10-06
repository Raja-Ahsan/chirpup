<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class ParentPinRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'user_pin' => ['required', 'string', 'digits:4'],
        ];
    }

    public function messages(): array
    {
        return [
            'user_pin.digits' => 'The parent pin must be exactly 4 digits.',
        ];
    }
}
