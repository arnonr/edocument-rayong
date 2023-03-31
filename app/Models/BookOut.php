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
        'book_out_category_id',
        'book_out_type_id',
        'receive_date',
        'return_date',
        'book_no',
        'book_date',
        'to_send',
        'book_out_file',
        'book_out_success_file',
        'department_id',
        'book_to',
        'book_reference',
        'book_year_id',
        'remark',
        'status_id',
        'user_id',
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
