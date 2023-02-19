<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookIn;
use App\Models\BookInType;
use App\Models\BookYear;
use Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;
const whitelist = ['127.0.0.1', "::1","localhost:8109"];

class BookInController extends Controller
{
    protected $uploadUrl = 'http://143.198.208.110:8109/storage';
    // protected $uploadUrl = 'http://localhost:8109/storage';
    public function getAll(Request $request)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8109/storage';
        }

        $items = BookIn::select(
            'book_in.id as id',
            'book_in.title as title',
            'book_in.book_in_category_id as book_in_category_id',
            'book_in.book_in_type_id as book_in_type_id',
            'book_in.book_year_id as book_year_id',
            'book_in.book_from_no as book_from_no',
            'book_in.book_from_date as book_from_date',
            'book_in.book_from as book_from',
            'book_in.receive_date as receive_date',
            'book_in.book_no as book_no',
            'book_in.to_send as to_send',
            // 'book_in.book_in_file as book_in_file',
            // 'book_in_success_file as book_in_success_file',
            DB::raw("(CASE WHEN book_in_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_in_file) END) AS book_in_file"),
            DB::raw("(CASE WHEN book_in_success_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_in_success_file) END) AS book_in_success_file"),
            'book_in.department_to as department_to',
            'book_in.book_to as book_to',
            'book_in.book_reference as book_reference',
            'book_in.remark as remark',
            'book_in.status_id as status_id',
            'book_in.book_page_count as book_page_count',
            'book_in.book_page_count_sum as book_page_count_sum',
            'book_in_category.name as book_in_category_name',
            'book_in_type.name as book_in_type_name',
            'book_year.name as book_year_name',
            'department.name as department_name',
            'book_in.is_publish as is_publish',
            'book_in.deleted_at as delete_at',
            'book_in.created_at as created_at',
            'book_in.created_by as created_by',
            'book_in.updated_at as updated_at',
            'book_in.updated_by as updated_by',
        )
        ->join('book_in_category','book_in.book_in_category_id','=','book_in_category.id')
        ->join('book_in_type','book_in.book_in_type_id','=','book_in_type.id')
        ->join('book_year','book_in.book_year_id','=','book_year.id')
        ->leftJoin('department','book_in.department_to','=','department.id')
        ->where('book_in.deleted_at', null);
        
        if ($request->book_year_id) {
            $items->where('book_in.book_year_id',$request->book_year_id);
        }else{
            $items->where('book_year.status', 1);
        }


        if ($request->id) {
            $items->where('book_in.id',$request->id);
        }

        if ($request->title) {
            $items->where('book_in.title','LIKE',"%".$request->title."%");
        }

        if ($request->book_in_category_id) {
            $items->where('book_in.book_in_category_id',$request->book_in_category_id);
        }

        if ($request->book_in_type_id) {
            $items->where('book_in.book_in_type_id',$request->book_in_type_id);
        }

        if ($request->book_from_no) {
            $items->where('book_in.book_from_no','LIKE',"%".$request->book_from_no."%");
        }

        if ($request->book_from_date) {
            $items->where('book_in.book_from_date',$request->book_from_date);
        }

        if ($request->book_from) {
            $items->where('book_in.book_from','LIKE',"%".$request->book_from."%");
        }

        if ($request->receive_date) {
            $items->where('book_in.receive_date',$request->receive_date);
        }

        if ($request->book_no) {
            $items->where('book_in.book_no','LIKE',"%".$request->book_no."%");
        }

        if ($request->to_send) {
            $items->where('book_in.to_send','LIKE',"%".$request->to_send."%");
        }

        if ($request->department_to) {
            $items->where('book_in.department_to',$request->department_to);
        }

        if ($request->is_publish) {
            $items->where('book_in.is_publish',$request->is_publish);
        }

        if ($request->start_receive_date) {
            $startDate = Carbon::createFromFormat('Y-m-d', $request->start_receive_date);
            $items->whereDate('receive_date','>=', $startDate);
        }

        if ($request->end_receive_date) {
            $endDate = Carbon::createFromFormat('Y-m-d', $request->end_receive_date);
            $items->whereDate('receive_date','<=', $endDate);
        }

        $order_by = $request->orderBy ? $request->orderBy : 'id';
        $order = $request->order ? $request->order : 'asc';

        $items = $items->orderBy($order_by, $order);
            
        $count = $items->count();
        $perPage = $request->perPage ? $request->perPage : 10;
        $currentPage = $request->currentPage ? $request->currentPage : 1;

        $totalPage = ceil($count /$perPage) == 0 ? 1 : ceil($count / $perPage);
        $offset = $perPage * ($currentPage - 1);
        $items = $items->skip($offset)->take($perPage);
        $items = $items->get();

        return response()->json([
            'message' => 'success',
            'data' => $items,
            'totalPage' => $totalPage,
            'totalData' => $count,
        ], 200);
    }

    public function get($id)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8109/storage';
        }
        // User DB
        
        $data = BookIn::select(
            'book_in.id as id',
            'book_in.title as title',
            'book_in.book_in_category_id as book_in_category_id',
            'book_in.book_in_type_id as book_in_type_id',
            'book_in.book_year_id as book_year_id',
            'book_in.book_from_no as book_from_no',
            'book_in.book_from_date as book_from_date',
            'book_in.book_from as book_from',
            'book_in.receive_date as receive_date',
            'book_in.book_no as book_no',
            'book_in.to_send as to_send',
            DB::raw("(CASE WHEN book_in_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_in_file) END) AS book_in_file"),
            DB::raw("(CASE WHEN book_in_success_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_in_success_file) END) AS book_in_success_file"),
            'book_in.department_to as department_to',
            'book_in.book_to as book_to',
            'book_in.book_reference as book_reference',
            'book_in.remark as remark',
            'book_in.status_id as status_id',
            'book_in.book_page_count as book_page_count',
            'book_in.book_page_count_sum as book_page_count_sum',
            'book_in_category.name as book_in_category_name',
            'book_in_type.name as book_in_type_name',
            'book_year.name as book_year_name',
            'department.name as department_name',
            'book_in.is_publish as is_publish',
            'book_in.deleted_at as delete_at',
            'book_in.created_at as created_at',
            'book_in.created_by as created_by',
            'book_in.updated_at as updated_at',
            'book_in.updated_by as updated_by',
        )
        ->join('book_in_category','book_in.book_in_category_id','=','book_in_category.id')
        ->join('book_in_type','book_in.book_in_type_id','=','book_in_type.id')
        ->join('book_year','book_in.book_year_id','=','book_year.id')
        ->leftJoin('department','book_in.department_to','=','department.id')
        ->where('book_in.id', $id)
        ->first();
        
        return response()->json([
            'message' => 'success',
            'data' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'book_in_category_id' => 'required|integer',
            'book_in_type_id' => 'required|integer',
            'book_from_no' => 'nullable|string',
            'book_from_date' => 'nullable|date',
            'book_from' => 'nullable|string',
            'receive_date' => 'date',
            'book_no' => 'required|string',
            'to_send' => 'nullable|string',
            'book_in_file' => 'nullable',
            'book_in_success_file' => 'nullable',
            'department_to' => 'nullable',
            'book_to' => 'nullable|string',
            'book_reference' => 'nullable|string',
            'remark' => 'string',
            'status_id' => 'nullable|integer',
            'is_publish' => 'nullable|integer',
        ]);

        // แยก book_no กับ year
        $code_split = str_replace("/","-",$request->book_no);
        $code_explode = explode("-", $code_split);
        $year = $code_explode[1];
        $code = $code_explode[0];

        $book_year = BookYear::where('name',$year)->where('deleted_at', null)->first();

        // Check Book No Duplicate.
        $book_in = BookIn::where('book_no', $request->book_no)
            ->where('book_in_category_id', $request->book_in_category_id)
            ->where('deleted_at', null)
            ->first();

        if($book_in){
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $request->book_no
            ], 200);
        }

        $book_page_count = 1;
        $book_page_count_sum = 1;

        // Save File
        $path_file = null;
        if(($request->book_in_file != "") && ($request->book_in_file != 'null')){
            $file_name = $code.'-'.$year.'-'.$request->book_in_file->getClientOriginalName();
            $path_file = '/document/book-in/'.$year.'/'.$file_name;
            Storage::disk('public')->put($path_file, file_get_contents($request->book_in_file));
            // Count Page
            $pdftext = file_get_contents($request->book_in_file);
            $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            return response()->json([
                'message' => 'error Not File Upload'
            ], 200);
        }

        // Save File Success
        $path_success_file = null;
        if(($request->book_in_success_file != "") && ($request->book_in_success_file != 'null')){
            $file_name_success = $code.'-'.$year.'-'.$request->book_in_success_file->getClientOriginalName();
            $path_success_file = '/document/book-in/'.$year.'/success/'.$file_name_success;
            Storage::disk('public')->put($path_success_file, file_get_contents($request->book_in_success_file));
            // Count Page
            // $pdftext = file_get_contents($book_in_success_file);
            // $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }

        // Sendmail 
        $count_book_to = 1;
        if($request->book_to != 'null'){
            foreach(json_decode($request->book_to, true) as $key => $value){
                $count_book_to++;
                // $this->sendMail($value['email'], $data);
            }
        }
        $book_page_count_sum = $book_page_count * $count_book_to;

        $data = new BookIn;
        $data->title = $request->title;
        $data->book_in_category_id = $request->book_in_category_id;
        $data->book_in_type_id = $request->book_in_type_id;
        $data->book_from_no = $request->book_from_no;
        $data->book_from_date = $request->book_from_date;
        $data->book_from = $request->book_from;
        $data->receive_date = $request->receive_date;
        $data->book_no = $request->book_no;
        $data->to_send = $request->to_send;
        $data->book_in_file = $path_file;
        $data->book_in_success_file = $path_success_file;
        $data->department_to = $request->department_to == 'null' ? null : $request->department_to;
        $data->book_to = $request->book_to == 'null' ? null : $request->book_to;
        $data->book_reference = $request->book_reference;
        $data->book_year_id = $book_year->id;
        $data->remark = $request->remark;
        $data->status_id = $request->status_id;
        $data->book_page_count = $book_page_count;
        $data->book_page_count_sum = $book_page_count_sum;
        $data->is_publish = 1;
        $data->created_by = 'arnonr';
        $data->save();

        if($request->book_to != 'null'){
            foreach(json_decode($request->book_to, true) as $key => $value){
                $this->sendMail($value['email'], $data);
            }
        }

        $responseData = [
            'message' => 'success',
            'data' => $data,
        ];
        
        return response()->json($responseData, 200);
    }

    public function edit($id, Request $request)
    {
        $request->validate([
            'id' => 'required|integer',
            'title' => 'required|string',
            'book_in_category_id' => 'required|integer',
            'book_in_type_id' => 'required|integer',
            'book_from_no' => 'nullable|string',
            'book_from_date' => 'nullable|date',
            'book_from' => 'nullable|string',
            'receive_date' => 'date',
            'book_no' => 'required|string',
            'to_send' => 'nullable|string',
            'book_in_file' => 'nullable',
            'book_in_success_file' => 'nullable',
            'department_to' => 'nullable',
            'book_to' => 'nullable|string',
            'book_reference' => 'nullable|string',
            'remark' => 'string',
            'status_id' => 'nullable|integer',
            'is_publish' => 'nullable|integer',
        ]);

        $id = $request->id;

        // แยก book_no กับ year
        $code_split = str_replace("/","-",$request->book_no);
        $code_explode = explode("-", $code_split);
        $year = $code_explode[1];
        $code = $code_explode[0];

        $book_year = BookYear::where('name',$year)->where('deleted_at', null)->first();

        // Check Book No Duplicate.
        $book_in = BookIn::where('book_no', $request->book_no)
            ->where('book_in_category_id', $request->book_in_category_id)
            ->where('id','!=', $id)
            ->where('deleted_at', null)
            ->first();

        if($book_in){
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $request->book_no
            ], 200);
        }

        $data = BookIn::where('id', $id)->first();

        $book_page_count = 1;
        $book_page_count_sum = 1;

        // Save File
        $path_file = null;
        if(($request->book_in_file != "") && ($request->book_in_file != 'null')){
            $file_name = $code.'-'.$year.'-'.$request->book_in_file->getClientOriginalName();
            $path_file = '/document/book-in/'.$year.'/'.$file_name;
            Storage::disk('public')->put($path_file, file_get_contents($request->book_in_file));
            // Count Page
            $pdftext = file_get_contents($request->book_in_file);
            $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            $path_file = $data->book_in_file;
        }

        // Save File Success
        $path_success_file = null;
        if(($request->book_in_success_file != "") && ($request->book_in_success_file != 'null')){
            $file_name_success = $code.'-'.$year.'-'.$request->book_in_success_file->getClientOriginalName();
            $path_success_file = '/document/book-in/'.$year.'/success/'.$file_name_success;
            Storage::disk('public')->put($path_success_file, file_get_contents($request->book_in_success_file));
            // Count Page
            // $pdftext = file_get_contents($book_in_success_file);
            // $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            $path_success_file = $data->book_in_success_file;
        }

        // Sendmail 
        $count_book_to = 1;
        if($request->book_to != 'null'){
            foreach(json_decode($request->book_to, true) as $key => $value){
                $count_book_to++;
                // $this->sendMail($value['email'], $data);
            }
        }
        $book_page_count_sum = $book_page_count * $count_book_to;

        $data->title = $request->title;
        $data->book_in_category_id = $request->book_in_category_id;
        $data->book_in_type_id = $request->book_in_type_id;
        $data->book_from_no = $request->book_from_no;
        $data->book_from_date = $request->book_from_date;
        $data->book_from = $request->book_from;
        $data->receive_date = $request->receive_date;
        $data->book_no = $request->book_no;
        $data->to_send = $request->to_send;
        $data->book_in_file = $path_file;
        $data->book_in_success_file = $path_success_file;
        $data->department_to = $request->department_to == 'null' ? null : $request->department_to;
        $data->book_to = $request->book_to == 'null' ? null : $request->book_to;
        $data->book_reference = $request->book_reference;
        $data->book_year_id = $book_year->id;
        $data->remark = $request->remark;
        $data->status_id = $request->status_id;
        $data->book_page_count = $book_page_count;
        $data->book_page_count_sum = $book_page_count_sum;
        $data->is_publish = 1;
        $data->created_by = 'arnonr';
        $data->save();

        if(($request->is_send_email == true) && ($request->is_send_email != 'undefined')){
            if($request->book_to != 'null'){
                foreach(json_decode($request->book_to, true) as $key => $value){
                    $this->sendMail($value['email'], $data);
                }
            }
        }   

        $responseData = [
            'message' => 'success',
            'data' => $data,
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookIn::where('id', $id)->first();

        $data->deleted_at = Carbon::now();
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }

    public function generateCode(Request $request)
    {
        // Get Latest
        if(isset($request->book_year_id)){
            $book_year = BookYear::where('id',$request->book_year_id)->first();

        }else{
            $book_year = BookYear::where('status', 1)->first();

        }

        $data = BookIn::where('deleted_at', null)
            ->where('book_in_category_id', $request->book_in_category_id)
            ->where('book_year_id', $book_year->id)
            ->whereNotNull('book_no')
            ->orderBy('book_no', 'desc')
            ->first();

        // $book_year = BookYear::where('id', $request->book_year_id)
        //     ->first();

        $code_latest = "";
        $code_next = "";
        if($data){

            $code_latest = $data->book_no;
            $code = explode("/", $code_latest);
            $code_next = floor(intval($code[0]))+1;
            
            $count = strlen($code_next);
            if($request->book_in_category_id % 2 == 1){
                $code_next = (string)$code_next;

                for($count; $count<4; $count++){
                    
                    $code_next = "0".$code_next;
                }
            }else{
                $code_next = (string)$code_next;
                for($count; $count<3; $count++){
                    $code_next = "0".$code_next;
                }
            }
            $code_next = $code_next.'/'.$code[1];
        }else{
            $code_latest = "000/".$book_year->name;
            $code_next= "001/".$book_year->name;
            if($request->book_in_category_id % 2 == 1){
                $code_latest = "0000/".$book_year->name;
                $code_next = "0001/".$book_year->name;
            }
           
           
        }
        // codeLastest

        return response()->json([
            'message' => 'success',
            'data' => [
                'code_lastest' => $code_latest,
                'code_next' => $code_next,
            ],
        ], 200);
    }

    public function sendMail($email, $data){

        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8109/storage';
        }
        
        $sendmail = true;
        $template = 'bookInSend';

        $thai_months = [
            1 => 'ม.ค.',
            2 => 'ก.พ.',
            3 => 'มี.ค.',
            4 => 'เม.ย.',
            5 => 'พ.ค.',
            6 => 'มิ.ย.',
            7 => 'ก.ค.',
            8 => 'ส.ค.',
            9 => 'ก.ย.',
            10 => 'ต.ค.',
            11 => 'พ.ย.',
            12 => 'ธ.ค.',
        ];

        $date_receive = Carbon::parse($data->date_receive);
        $month = $thai_months[$date_receive->month];
        $year = $date_receive->year + 543;
        $date_receive = $date_receive->format("j $month $year");

        $details = [
            'title' => $data->title,
            'body' => '
            เรื่อง : '.$data->title.'<br>
            จาก : '.$data->book_from.'<br>
            วันที่รับ : '.$date_receive.'<br>
            ไฟล์เอกสาร: <a href="'.$this->uploadUrl.$data->book_in_file.'">เปิดไฟล์</a>'
        ];

         // ไฟล์เอกสาร: <a href="'.env('APP_URL').'http://edoc.fba.kmutnb.ac.th/storage'.$data->file.'">เปิดไฟล์</a>'
        // ไฟล์เอกสาร: <a href="'.env('APP_URL').'storage'.$data->file.'">เปิดไฟล์</a>'
        // var_dump($data->file);
        $file1 = public_path($data->book_in_file);

        try {
            // \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->file), $details, function($message)use($details , $data, $file1, $email) {
            //     $message->to($email)->subject($data->title)->attach($file1);
            // });
            \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->book_in_file));
        } catch (Throwable $e) {
            $sendmail = false;
        }
    }
}
