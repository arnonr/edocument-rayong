<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Mou extends Model
{

    use HasFactory;
    protected $table = 'mou';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'partner',
        'partner_logo_file',
        'mou_file',
        'mou_word_file',
        'host_id',
        'country_code',
        'start_date',
        'end_date',
        'address',
        'type',
        'is_publish',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'deleted_at',
        'host_contact_name',
        'host_contact_phone',
        'host_contact_email',
        'partner_contact_name',
        'partner_contact_phone',
        'partner_contact_email',
        'remark',
    ];

    // public function host()
    // {
    //     return  $this->belongsTo(Host::Class, 'host_id', 'id');
    // }

    // public function country()
    // {
    //     return  $this->belongsTo(Country::Class, 'country_code', 'ct_code');
    // }
}
