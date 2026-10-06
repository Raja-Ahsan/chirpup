<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateChildMoodRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if ($this->filled('childern_id') && ! $this->filled('children_id')) {
            $this->merge([
                'children_id' => $this->input('childern_id'),
            ]);
        }
    }

    public function rules(): array
    {
        $child = $this->route('child');

        return [
            'children_id' => [
                'required',
                'integer',
                Rule::in([$child?->id]),
            ],
            'mood_id' => [
                'required',
                'integer',
                Rule::exists('game_mood', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'date' => ['required', 'date', 'date_format:Y-m-d'],
        ];
    }

    public function messages(): array
    {
        return [
            'children_id.in' => 'The children id does not match this child profile.',
            'date.date_format' => 'The date must be in Y-m-d format.',
        ];
    }
}
