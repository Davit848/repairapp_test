<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::with('shop')->latest();

        // Optional filters: ?search=brake&vehicle_type=motor&category=Brake&shop_id=1
        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('category', 'like', "%{$search}%")
                    ->orWhere('vehicle_type', 'like', "%{$search}%")
                    ->orWhereHas('shop', fn ($s) => $s->where('name', 'like', "%{$search}%"));
            });
        }
        if ($vehicleType = $request->query('vehicle_type')) {
            $query->where('vehicle_type', $vehicleType);
        }
        if ($category = $request->query('category')) {
            $query->where('category', $category);
        }
        if ($shopId = $request->query('shop_id')) {
            $query->where('shop_id', $shopId);
        }

        return response()->json($query->get(), 200);
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
        $shop = $user->shop()->first();
        if (!$shop) {
            return response()->json(['message' => 'You must create a shop before adding products.'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'description' => 'required|string',
            'image' => 'nullable|string',
            'vehicle_type' => 'required|in:car,motor',
            'category' => 'required|string|max:100',
        ]);

        $validated['shop_id'] = $shop->id;
        $product = Product::create($validated);

        return response()->json($product->load('shop'), 201);
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
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'description' => 'sometimes|required|string',
            'image' => 'nullable|string',
            'vehicle_type' => 'sometimes|required|in:car,motor',
            'category' => 'sometimes|required|string|max:100',
        ]);

        $product->update($validated);

        return response()->json($product->load('shop'), 200);
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