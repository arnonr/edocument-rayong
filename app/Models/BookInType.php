<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookInType extends Model
{

    use HasFactory;
    protected $table = 'book_in_type';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'book_in_category_id',
        'is_publish',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'deleted_at',
    ];

    public function bookInCategory() {
        return $this->belongsTo(bookInCategory::class,'book_in_category_id','id');
    }
}
