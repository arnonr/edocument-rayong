<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookCategory extends Model
{

    use HasFactory;
    protected $table = 'book_category';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'title',
        'created_at',
        'updated_at',
        'active'
    ];
}
