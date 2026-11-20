<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreBookmarkRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if (! $this->filled('user_id') && $this->user()) {
            $this->merge([
                'user_id' => $this->user()->id,
            ]);
        }

        if ($this->filled('character_id') && ! $this->filled('child_id')) {
            $this->merge([
                'child_id' => $this->input('character_id'),
            ]);
        }

        $css = $this->input('css_style_json');
        if (is_string($css) && $css !== '') {
            $decoded = json_decode($css, true);
            if (json_last_error() === JSON_ERROR_NONE) {
                $this->merge([
                    'css_style_json' => $decoded,
                ]);
            }
        }
    }

    public function rules(): array
    {
        $userId = $this->user()?->id;

        return [
            'user_id' => [
                'required',
                'integer',
                Rule::exists('users', 'id'),
                Rule::in([$userId]),
            ],
            'child_id' => [
                'required',
                'integer',
                Rule::exists('children', 'id')->where(function ($query) use ($userId) {
                    $query->where('user_id', $userId)->whereNull('deleted_at');
                }),
            ],
            'year_id' => [
                'required',
                'integer',
                Rule::exists('years', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'category_id' => ['nullable', 'integer'],
            'game_category_id' => [
                'required',
                'integer',
                Rule::exists('game_categories', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'sketche_id' => [
                'required',
                'integer',
                Rule::exists('games_type_sketches', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'sketche_image_id' => ['nullable', 'integer'],
            'sketch_complete_image_url' => [
                'required',
                'file',
                'image',
                'mimes:jpeg,jpg,png,webp',
                'max:5120',
            ],
            'play_date' => ['required', 'date', 'date_format:Y-m-d'],
            'css_style_json' => ['nullable', 'array'],
        ];
    }

    public function messages(): array
    {
        return [
            'user_id.in' => 'The user id must match the authenticated user.',
            'child_id.exists' => 'The selected child id is invalid.',
            'sketche_id.exists' => 'The selected sketche id is invalid. Use a sketch id from start_game nested sketches (not the game type id).',
            'play_date.date_format' => 'The play date must be in Y-m-d format.',
            'sketch_complete_image_url.required' => 'Please upload the bookmark sketch image.',
            'sketch_complete_image_url.image' => 'The bookmark sketch must be an image file.',
        ];
    }
}
