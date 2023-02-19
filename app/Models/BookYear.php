<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookYear extends Model
{

    use HasFactory;
    protected $table = 'book_year';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'status',
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
