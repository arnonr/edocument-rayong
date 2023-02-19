<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class EmailGroup extends Model
{

    use HasFactory;
    protected $table = 'email_group';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'email_all',
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
