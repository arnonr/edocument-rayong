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
        'group_no',
        'created_at',
        'updated_at',
        'active'
    ];
}
