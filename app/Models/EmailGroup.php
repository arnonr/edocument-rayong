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
        'created_at',
        'updated_at',
        'active'
    ];
}
