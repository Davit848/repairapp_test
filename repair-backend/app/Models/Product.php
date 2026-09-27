<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'shop_id',
        'name',
        'price',
        'stock',
        'description',
        'image',
        'vehicle_type',
        'category'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
