<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Setting extends Model
{

    use HasFactory;
    protected $table = 'setting';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'email',
        'password',
        'created_at',
        'updated_at',
        'active'
    ];
}
