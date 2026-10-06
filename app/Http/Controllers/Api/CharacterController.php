<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CharacterCollection;
use App\Http\Resources\CharacterResource;
use App\Models\Character;
use Illuminate\Http\JsonResponse;

class CharacterController extends Controller
{
    public function index(): CharacterCollection
    {
        $characters = Character::query()
            ->where('status', 'active')
            ->orderBy('id')
            ->get();

        return new CharacterCollection($characters);
    }

    public function show(Character $character): JsonResponse
    {
        if ($character->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Character not found.',
                'data' => null,
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Character fetched successfully.',
            'data' => [
                'character' => new CharacterResource($character),
            ],
        ]);
    }
}
