<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookInCategory extends Model
{

    use HasFactory;
    protected $table = 'book_in_category';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'book_year_id',
        'level',
        'is_publish',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'deleted_at',
    ];

    // public function project() {
    //     return $this->belongsTo(Project::class);
    // }
}
