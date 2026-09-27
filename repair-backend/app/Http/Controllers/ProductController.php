<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        return response()->json(Product::with('shop')->get(), 200);
    }

    public function show($id)
    {
        $product = Product::with('shop')->findOrFail($id);
        return response()->json($product, 200);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        
        // User must have a shop to create a product
        if (!$user->shop) {
            return response()->json(['message' => 'You must create a shop before adding products.'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'stock' => 'required|integer',
            'description' => 'required|string',
            'image' => 'nullable|string',
            'vehicle_type' => 'required|string', // car or motor
            'category' => 'required|string',
        ]);

        $validated['shop_id'] = $user->shop->id;
        $product = Product::create($validated);

        return response()->json($product, 201);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        // Security check: Product must belong to the authenticated user's shop
        if ($product->shop->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric',
            'stock' => 'sometimes|required|integer',
            'description' => 'sometimes|required|string',
            'image' => 'nullable|string',
            'vehicle_type' => 'sometimes|required|string',
            'category' => 'sometimes|required|string',
        ]);

        $product->update($validated);

        return response()->json($product, 200);
    }

    public function destroy(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        if ($product->shop->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $product->delete();

        return response()->json(['message' => 'Product deleted successfully.'], 200);
    }
}