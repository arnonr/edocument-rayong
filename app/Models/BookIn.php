<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BookIn extends Model
{

    use HasFactory;
    protected $table = 'book_in';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'title',
        'book_no',
        'category_id',
        'book_from_no',
        'book_from_date',
        'book_from',
        'file',
        'file_success',
        'detail',
        'date_receive',
        'dep_to',
        'to_send',
        'book_to',
        'book_reference',
        'book_code_id',
        'book_year_id',
        'status',
        'created_at',
        'updated_at',
        'active',
        'book_page_count',
        'book_page_count_sum',
    ];
}
