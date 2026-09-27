<?php

namespace App\Http\Controllers;

use App\Models\Shop;
use Illuminate\Http\Request;

class ShopController extends Controller
{
    public function index()
    {
        return response()->json(Shop::with('user', 'products')->get(), 200);
    }

    public function show($id)
    {
        $shop = Shop::with('user', 'products')->findOrFail($id);
        return response()->json($shop, 200);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        
        // Ensure user doesn't already have a shop (1-to-1 relationship)
        if ($user->shop()->exists()) {
            return response()->json(['message' => 'You already own a shop.'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'description' => 'nullable|string',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'address' => 'required|string',
            'image' => 'nullable|string' // Or handle file upload logic
        ]);

        $validated['user_id'] = $user->id;
        $shop = Shop::create($validated);

        return response()->json($shop, 201);
    }

    public function update(Request $request, $id)
    {
        $shop = Shop::findOrFail($id);

        // Security check: Only the owner can update their shop
        if ($shop->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'phone' => 'sometimes|required|string|max:20',
            'description' => 'nullable|string',
            'latitude' => 'sometimes|required|numeric',
            'longitude' => 'sometimes|required|numeric',
            'address' => 'sometimes|required|string',
            'image' => 'nullable|string'
        ]);

        $shop->update($validated);

        return response()->json($shop, 200);
    }

    public function destroy(Request $request, $id)
    {
        $shop = Shop::findOrFail($id);

        if ($shop->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $shop->delete();

        return response()->json(['message' => 'Shop deleted successfully.'], 200);
    }
}