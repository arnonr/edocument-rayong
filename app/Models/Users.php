<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class User extends Model
{
    use HasFactory;
    protected $table = 'users';
    protected $primaryKey = 'id';

    protected $fillable = [
        'icit_name',
        'icit_email',
        'prefix',
        'firstname',
        'name',
        'lastname',
        'email',
        'avatar',
        'email_verified_at',
        'username',
        'password',
        'pid',
        'account_type',
        'type',
        'status',
        'dep_id',
        'email_person_id',
        'remember_token',
        'created_at',
        'updated_at',
    ];
}
