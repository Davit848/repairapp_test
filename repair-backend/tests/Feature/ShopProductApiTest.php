<?php

namespace Tests\Feature;

use App\Models\Product;
use App\Models\Shop;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ShopProductApiTest extends TestCase
{
    use RefreshDatabase;

    private function authHeader(User $user): array
    {
        return ['Authorization' => 'Bearer ' . $user->createToken('test')->plainTextToken];
    }

    private function shopData(array $overrides = []): array
    {
        return array_merge([
            'name' => 'ABC Garage',
            'phone' => '012345678',
            'description' => 'Car and motor repair',
            'latitude' => 11.5564,
            'longitude' => 104.9282,
            'address' => 'Phnom Penh',
        ], $overrides);
    }

    private function productData(array $overrides = []): array
    {
        return array_merge([
            'name' => 'Brake Pad',
            'price' => 25,
            'stock' => 10,
            'description' => 'Front brake pad',
            'vehicle_type' => 'motor',
            'category' => 'Brake',
        ], $overrides);
    }

    public function test_register_validates_input(): void
    {
        $this->postJson('/api/register', [
            'name' => '',
            'email' => 'not-an-email',
            'phone' => 'abc',
            'password' => 'short',
            'password_confirmation' => 'different',
        ])->assertStatus(422)->assertJsonValidationErrors(['name', 'email', 'phone', 'password']);
    }

    public function test_register_rejects_duplicate_email(): void
    {
        User::factory()->create(['email' => 'davit@gmail.com']);

        $this->postJson('/api/register', [
            'name' => 'Davit',
            'email' => 'davit@gmail.com',
            'phone' => '012345678',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ])->assertStatus(422)->assertJsonValidationErrors(['email']);
    }

    public function test_register_and_logout_revokes_token(): void
    {
        $token = $this->postJson('/api/register', [
            'name' => 'Davit',
            'email' => 'davit@gmail.com',
            'phone' => '012 345 678',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ])->assertStatus(201)->json('access_token');

        $headers = ['Authorization' => "Bearer {$token}"];
        $this->getJson('/api/user', $headers)->assertOk()->assertJsonPath('shop', null);
        $this->postJson('/api/logout', [], $headers)->assertOk();

        $this->app['auth']->forgetGuards();
        $this->getJson('/api/user', $headers)->assertUnauthorized();
    }

    public function test_user_can_create_only_one_shop_and_profile_includes_it(): void
    {
        $user = User::factory()->create();
        $headers = $this->authHeader($user);

        $this->postJson('/api/shops', $this->shopData(), $headers)->assertStatus(201);
        $this->postJson('/api/shops', $this->shopData(['name' => 'Second']), $headers)->assertStatus(403);

        $this->getJson('/api/user', $headers)->assertOk()->assertJsonPath('shop.name', 'ABC Garage');
        $this->assertSame(1, Shop::count());
    }

    public function test_guest_cannot_create_shop_or_product(): void
    {
        $this->postJson('/api/shops', $this->shopData())->assertUnauthorized();
        $this->postJson('/api/products', $this->productData())->assertUnauthorized();
    }

    public function test_user_without_shop_cannot_create_product(): void
    {
        $user = User::factory()->create();

        $this->postJson('/api/products', $this->productData(), $this->authHeader($user))->assertStatus(403);
    }

    public function test_owner_can_manage_products_but_others_cannot(): void
    {
        $owner = User::factory()->create();
        $ownerHeaders = $this->authHeader($owner);
        $this->postJson('/api/shops', $this->shopData(), $ownerHeaders)->assertStatus(201);

        $productId = $this->postJson('/api/products', $this->productData(), $ownerHeaders)
            ->assertStatus(201)
            ->assertJsonPath('shop.name', 'ABC Garage')
            ->json('id');

        $this->app['auth']->forgetGuards();
        $other = User::factory()->create();
        $otherHeaders = $this->authHeader($other);
        $this->putJson("/api/products/{$productId}", ['price' => 1], $otherHeaders)->assertStatus(403);
        $this->deleteJson("/api/products/{$productId}", [], $otherHeaders)->assertStatus(403);

        $this->app['auth']->forgetGuards();
        $this->putJson("/api/products/{$productId}", ['price' => 30], $ownerHeaders)->assertOk();
        $this->assertEquals(30, Product::find($productId)->price);
        $this->deleteJson("/api/products/{$productId}", [], $ownerHeaders)->assertOk();
        $this->assertSame(0, Product::count());
    }

    public function test_product_validation_rejects_bad_values(): void
    {
        $user = User::factory()->create();
        $headers = $this->authHeader($user);
        $this->postJson('/api/shops', $this->shopData(), $headers)->assertStatus(201);

        $this->postJson('/api/products', $this->productData([
            'price' => -5,
            'stock' => 'ten',
            'vehicle_type' => 'boat',
        ]), $headers)->assertStatus(422)->assertJsonValidationErrors(['price', 'stock', 'vehicle_type']);
    }

    public function test_products_can_be_searched_by_shop_name(): void
    {
        $user = User::factory()->create();
        $headers = $this->authHeader($user);
        $this->postJson('/api/shops', $this->shopData(), $headers)->assertStatus(201);
        $this->postJson('/api/products', $this->productData(), $headers)->assertStatus(201);

        $this->getJson('/api/products?search=ABC')->assertOk()->assertJsonCount(1);
        $this->getJson('/api/products?search=nothing')->assertOk()->assertJsonCount(0);
        $this->getJson('/api/products?vehicle_type=car')->assertOk()->assertJsonCount(0);
    }
}
