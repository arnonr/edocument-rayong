<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookStatus extends Model
{

    use HasFactory;
    protected $table = 'book_status';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'title',
        'color',
        'created_at',
        'updated_at',
        'active'
    ];
}
