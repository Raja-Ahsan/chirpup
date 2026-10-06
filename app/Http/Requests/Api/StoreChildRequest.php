<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreChildRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'year_id' => [
                'required',
                'integer',
                Rule::exists('years', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'character_id' => [
                'required',
                'integer',
                Rule::exists('characters', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'pin_code' => ['nullable', 'string', 'digits:4'],
            'status' => ['sometimes', 'string', Rule::in(['active', 'inactive'])],
        ];
    }
}
