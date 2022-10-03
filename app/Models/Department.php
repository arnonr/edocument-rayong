<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Department extends Model
{

    use HasFactory;
    protected $table = 'department';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'created_at',
        'updated_at',
        'active'
    ];
}
