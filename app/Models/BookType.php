<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookType extends Model
{

    use HasFactory;
    protected $table = 'book_type';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'title',
        'acronym',
        'code',
        'year',
        'created_at',
        'updated_at',
        'active'
    ];
}
