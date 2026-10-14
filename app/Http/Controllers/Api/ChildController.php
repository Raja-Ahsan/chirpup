<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreChildRequest;
use App\Http\Requests\Api\UpdateChildMoodRequest;
use App\Http\Requests\Api\UpdateChildRequest;
use App\Http\Resources\ChildCollection;
use App\Http\Resources\ChildResource;
use App\Models\Child;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ChildController extends Controller
{
    public function index(Request $request): ChildCollection
    {
        $children = Child::query()
            ->with(['user', 'year', 'character', 'todayMoodEntry.mood', 'weekMoods.mood'])
            ->where('user_id', $request->user()->id)
            ->orderByDesc('id')
            ->get();

        return new ChildCollection($children);
    }

    public function store(StoreChildRequest $request): JsonResponse
    {
        $child = Child::query()->create([
            'user_id' => $request->user()->id,
            'name' => $request->string('name')->toString(),
            'year_id' => $request->integer('year_id'),
            'character_id' => $request->integer('character_id'),
            'pin_code' => $request->filled('pin_code') ? $request->string('pin_code')->toString() : null,
            'status' => $request->input('status', 'active'),
        ]);

        $child->load(['user', 'year', 'character', 'todayMoodEntry.mood', 'weekMoods.mood']);

        return response()->json([
            'success' => true,
            'message' => 'Child created successfully.',
            'data' => [
                'child' => new ChildResource($child),
            ],
        ], 201);
    }

    public function show(Request $request, Child $child): JsonResponse
    {
        if ($child->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Child not found.',
                'data' => null,
            ], 404);
        }

        $child->load(['user', 'year', 'character', 'todayMoodEntry.mood', 'weekMoods.mood']);

        return response()->json([
            'success' => true,
            'message' => 'Child fetched successfully.',
            'data' => [
                'child' => new ChildResource($child),
            ],
        ]);
    }

    public function update(UpdateChildRequest $request, Child $child): JsonResponse
    {
        if ($child->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Child not found.',
                'data' => null,
            ], 404);
        }

        $child->fill($request->only(['name', 'year_id', 'character_id', 'pin_code', 'status']));
        $child->save();
        $child->load(['user', 'year', 'character', 'todayMoodEntry.mood', 'weekMoods.mood']);

        return response()->json([
            'success' => true,
            'message' => 'Child updated successfully.',
            'data' => [
                'child' => new ChildResource($child),
            ],
        ]);
    }

    public function updateMood(UpdateChildMoodRequest $request, Child $child): JsonResponse
    {
        if ($child->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Child not found.',
                'data' => null,
            ], 404);
        }

        $date = $request->string('date')->toString();

        $alreadySet = $child->moods()
            ->whereDate('mood_date', $date)
            ->where('status', 'active')
            ->exists();

        if ($alreadySet) {
            return response()->json([
                'success' => false,
                'message' => 'You already set the mood today.',
                'data' => null,
            ], 422);
        }

        $child->moods()->create([
            'user_id' => $request->user()->id,
            'mood_id' => $request->integer('mood_id'),
            'mood_date' => $date,
            'status' => 'active',
        ]);

        $child->load(['user', 'year', 'character', 'todayMoodEntry.mood', 'weekMoods.mood']);

        return response()->json([
            'success' => true,
            'message' => 'Child mood updated successfully.',
            'data' => [
                'child' => new ChildResource($child),
            ],
        ]);
    }

    public function destroy(Request $request, Child $child): JsonResponse
    {
        if ($child->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Child not found.',
                'data' => null,
            ], 404);
        }

        $child->delete();

        return response()->json([
            'success' => true,
            'message' => 'Child deleted successfully.',
            'data' => null,
        ]);
    }
}
