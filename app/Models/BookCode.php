<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookCode extends Model
{

    use HasFactory;
    protected $table = 'book_code';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'book_in',
        'book_out',
        'year',
        'created_at',
        'updated_at',
        'active'
    ];
}
