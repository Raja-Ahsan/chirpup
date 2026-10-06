<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\YearCollection;
use App\Http\Resources\YearResource;
use App\Models\Year;
use Illuminate\Http\JsonResponse;

class YearController extends Controller
{
    public function index(): YearCollection
    {
        $years = Year::query()
            ->where('status', 'active')
            ->orderBy('id')
            ->get();

        return new YearCollection($years);
    }

    public function show(Year $year): JsonResponse
    {
        if ($year->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Year not found.',
                'data' => null,
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Year fetched successfully.',
            'data' => [
                'year' => new YearResource($year),
            ],
        ]);
    }
}
