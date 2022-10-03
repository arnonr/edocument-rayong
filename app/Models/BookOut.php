<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookOut extends Model
{

    use HasFactory;
    protected $table = 'book_out';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'title',
        'user_id',
        'book_type_id',
        'book_no',
        'book_to',
        'status_id',
        'dep_id',
        'file',
        'file_success',
        'detail',
        'to_send',
        'date_send',
        'date_receive',
        'date_return',
        'created_at',
        'updated_at',
        'active',
        'book_year_id',
        'book_page_count',
        'book_page_count_sum',
    ];
}
