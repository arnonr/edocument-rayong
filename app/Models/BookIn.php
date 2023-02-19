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
        'book_in_category_id',
        'book_in_type_id',
        'book_from_no',
        'book_from_date',
        'book_from',
        'receive_date',
        'book_no',
        'to_send',
        'book_in_file',
        'book_in_success_file',
        'department_to',
        'book_to',
        'book_reference',
        'book_year_id',
        'remark',
        'status_id',
        'book_page_count',
        'book_page_count_sum',
        'is_publish',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'deleted_at',
    ];

    // public function bookInCategory() {
    //     return $this->belongsTo(bookInCategory::class,'book_in_category_id','id');
    // }
}
