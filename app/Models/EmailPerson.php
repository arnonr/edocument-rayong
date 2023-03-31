<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class EmailPerson extends Model
{

    use HasFactory;
    protected $table = 'email_person';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'prefix',
        'firstname',
        'lastname',
        'email',
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
