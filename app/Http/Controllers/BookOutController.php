<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookOut;
use App\Models\BookYear;
use App\Models\BookStatus;
use Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;
const whitelist = ['127.0.0.1', "::1","localhost:8109"];

class BookOutController extends Controller
{
    protected $uploadUrl = 'http://143.198.208.110:8109/storage';
    // protected $uploadUrl = 'http://localhost:8109/storage';
    public function getAll(Request $request)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8109/storage';
        }

        $items = BookOut::select(
            'book_out.id as id',
            'book_out.title as title',
            'book_out.book_out_category_id as book_out_category_id',
            'book_out.book_year_id as book_year_id',
            'book_out.receive_date as receive_date',
            'book_out.return_date as return_date',
            'book_out.book_no as book_no',
            'book_out.book_date as book_date',
            'book_out.to_send as to_send',
            DB::raw("(CASE WHEN book_out_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_out_file) END) AS book_out_file"),
            DB::raw("(CASE WHEN book_out_success_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_out_success_file) END) AS book_out_success_file"),
            'book_out.department_id as department_id',
            'book_out.book_to as book_to',
            'book_out.book_reference as book_reference',
            'book_out.remark as remark',
            'book_out.status_id as status_id',
            'book_out.book_page_count as book_page_count',
            'book_out.book_page_count_sum as book_page_count_sum',
            'book_out_category.name as book_out_category_name',
            'book_year.name as book_year_name',
            'department.name as department_name',
            'book_status.name as status_name',
            'book_status.color as status_color',
            'book_out.user_id as user_id',
            DB::raw("CONCAT(prefix, firstname,' ', lastname) AS fullname"),
            'book_out.is_publish as is_publish',
            'book_out.deleted_at as delete_at',
            'book_out.created_at as created_at',
            'book_out.created_by as created_by',
            'book_out.updated_at as updated_at',
            'book_out.updated_by as updated_by',
        )
        ->join('book_out_category','book_out.book_out_category_id','=','book_out_category.id')
        ->join('book_year','book_out.book_year_id','=','book_year.id')
        ->join('book_status','book_out.status_id','=','book_status.id')
        ->join('users','book_out.user_id','=','users.id')
        ->leftJoin('department','book_out.department_id','=','department.id')
        ->where('book_out.deleted_at', null);
        
        if ($request->book_year_id) {
            $items->where('book_out.book_year_id',$request->book_year_id);
        }else{
            $items->where('book_year.status', 1);
        }

        if ($request->id) {
            $items->where('book_out.id',$request->id);
        }

        if ($request->title) {
            $items->where('book_out.title','LIKE',"%".$request->title."%");
        }

        if ($request->book_out_category_id) {
            $items->where('book_out.book_out_category_id',$request->book_out_category_id);
        }


        if ($request->receive_date) {
            $items->where('book_out.receive_date',$request->receive_date);
        }
        if ($request->return_date) {
            $items->where('book_out.return_date',$request->return_date);
        }
        if ($request->book_date) {
            $items->where('book_out.book_date',$request->book_date);
        }

        if ($request->book_no) {
            $items->where('book_out.book_no','LIKE',"%".$request->book_no."%");
        }

        if ($request->to_send) {
            $items->where('book_out.to_send','LIKE',"%".$request->to_send."%");
        }

        if ($request->department_id) {
            $items->where('book_out.department_id',$request->department_id);
        }

        if ($request->is_publish) {
            $items->where('book_out.book_out.is_publish',$request->is_publish);
        }

        if ($request->user_id) {
            $items->where('book_out.user_id',$request->user_id);
        }

        if ($request->status_id) {
            $items->where('book_out.status_is',$request->status_id);
        }

        if ($request->start_receive_date) {
            $startDate = Carbon::createFromFormat('Y-m-d', $request->start_receive_date);
            $items->whereDate('book_out.receive_date','>=', $startDate);
        }

        if ($request->end_receive_date) {
            $endDate = Carbon::createFromFormat('Y-m-d', $request->end_receive_date);
            $items->whereDate('book_out.receive_date','<=', $endDate);
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
        
        $item = BookOut::select(
            'book_out.id as id',
            'book_out.title as title',
            'book_out.book_out_category_id as book_out_category_id',
            'book_out.book_year_id as book_year_id',
            'book_out.receive_date as receive_date',
            'book_out.return_date as return_date',
            'book_out.book_no as book_no',
            'book_out.book_date as book_date',
            'book_out.to_send as to_send',
            DB::raw("(CASE WHEN book_out_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_out_file) END) AS book_out_file"),
            DB::raw("(CASE WHEN book_out_success_file = NULL THEN NULL
            ELSE CONCAT('".$this->uploadUrl."',book_out_success_file) END) AS book_out_success_file"),
            'book_out.department_id as department_id',
            'book_out.book_to as book_to',
            'book_out.book_reference as book_reference',
            'book_out.remark as remark',
            'book_out.status_id as status_id',
            'book_out.book_page_count as book_page_count',
            'book_out.book_page_count_sum as book_page_count_sum',
            'book_out_category.name as book_out_category_name',
            'book_year.name as book_year_name',
            'department.name as department_name',
            'book_status.name as status_name',
            'book_status.color as status_color',
            'book_out.user_id as user_id',
            DB::raw("CONCAT(prefix, firstname,' ', lastname) AS fullname"),
            'book_out.is_publish as is_publish',
            'book_out.deleted_at as delete_at',
            'book_out.created_at as created_at',
            'book_out.created_by as created_by',
            'book_out.updated_at as updated_at',
            'book_out.updated_by as updated_by',
        )
        ->join('book_out_category','book_out.book_out_category_id','=','book_out_category.id')
        ->join('book_year','book_out.book_year_id','=','book_year.id')
        ->join('book_status','book_out.status_id','=','book_status.id')
        ->join('users','book_out.user_id','=','users.id')
        ->leftJoin('department','book_out.department_id','=','department.id')
        ->where('book_out.id', $id)
        ->first();
        
        return response()->json([
            'message' => 'success',
            'data' => $item,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'book_out_category_id' => 'required|integer',
            'receive_date' => 'nullable',
            'return_date' => 'nullable',
            'book_no' => 'required|string',
            'book_date' => 'required',
            'to_send' => 'nullable|string',
            'book_out_file' => 'nullable',
            'book_out_success_file' => 'nullable',
            'department_id' => 'nullable',
            'book_to' => 'nullable|string',
            'book_reference' => 'nullable|string',
            'remark' => 'string',
            'status_id' => 'nullable|integer',
            'user_id' => 'required|integer',
            'is_publish' => 'nullable|integer',
        ]);

        // แยก book_no กับ year
        $code_split = str_replace("/","-",$request->book_no);
        $code_explode = explode("-", $code_split);
        $year = $code_explode[1];
        $code = $code_explode[0];

        $book_year = BookYear::where('name',$year)->where('deleted_at', null)->first();

        // Check Book No Duplicate.
        $book_out = BookOut::where('book_no', $request->book_no)
            ->where('book_out_category_id', $request->book_out_category_id)
            ->where('deleted_at', null)
            ->first();

        if($book_out){
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $request->book_no
            ], 200);
        }

        $book_page_count = 1;
        $book_page_count_sum = 1;

        // Save File
        $path_file = null;
        if(($request->book_out_file != "") && ($request->book_out_file != 'null')){
            $file_name = $code.'-'.$year.'-'.$request->book_out_file->getClientOriginalName();
            $path_file = '/document/book-out/'.$year.'/'.$file_name;
            Storage::disk('public')->put($path_file, file_get_contents($request->book_out_file));
            // Count Page
            $pdftext = file_get_contents($request->book_out_file);
            $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            return response()->json([
                'message' => 'error Not File Upload'
            ], 200);
        }

        // Save File Success
        $path_success_file = null;
        if(($request->book_out_success_file != "") && ($request->book_out_success_file != 'null')){
            $file_name_success = $code.'-'.$year.'-'.$request->book_out_success_file->getClientOriginalName();
            $path_success_file = '/document/book-out/'.$year.'/success/'.$file_name_success;
            Storage::disk('public')->put($path_success_file, file_get_contents($request->book_out_success_file));
            // Count Page
            // $pdftext = file_get_contents($book_out_success_file);
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

        $data = new BookOut;
        $data->title = $request->title;
        $data->book_out_category_id = $request->book_out_category_id;
        $data->receive_date = $request->receive_date == 'null' ? null : $request->receive_date;
        $data->return_date = $request->return_date == 'null' ? null : $request->return_date;
        $data->book_no = $request->book_no;
        $data->book_date = $request->book_date == 'null' ? null : $request->book_date;
        // sss
        $data->to_send = $request->to_send;
        $data->book_out_file = $path_file;
        $data->book_out_success_file = $path_success_file;
        $data->department_id = $request->department_id == 'null' ? null : $request->department_id;
        $data->book_to = $request->book_to == 'null' ? null : $request->book_to;
        $data->book_reference = $request->book_reference;
        $data->book_year_id = $book_year->id;
        $data->remark = $request->remark;
        $data->user_id = $request->user_id;
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
            'book_out_category_id' => 'required|integer',
            'receive_date' => 'nullable',
            'return_date' => 'nullable',
            'book_no' => 'required|string',
            'book_date' => 'required',
            'to_send' => 'nullable|string',
            'book_out_file' => 'nullable',
            'book_out_success_file' => 'nullable',
            'department_id' => 'nullable',
            'book_to' => 'nullable|string',
            'book_reference' => 'nullable|string',
            'remark' => 'string',
            'status_id' => 'nullable|integer',
            'user_id' => 'required|integer',
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
        $book_out = BookOut::where('book_no', $request->book_no)
            ->where('book_out_category_id', $request->book_out_category_id)
            ->where('id','!=', $id)
            ->where('deleted_at', null)
            ->first();

        if($book_out){
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $request->book_no
            ], 200);
        }

        $data = BookOut::where('id', $id)->first();

        $book_page_count = 1;
        $book_page_count_sum = 1;

        // Save File
        $path_file = null;
        if(($request->book_out_file != "") && ($request->book_out_file != 'null')){
            $file_name = $code.'-'.$year.'-'.$request->book_out_file->getClientOriginalName();
            $path_file = '/document/book-out/'.$year.'/'.$file_name;
            Storage::disk('public')->put($path_file, file_get_contents($request->book_out_file));
            // Count Page
            $pdftext = file_get_contents($request->book_out_file);
            $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            $path_file = $data->book_out_file;
        }

        // Save File Success
        $path_success_file = null;
        if(($request->book_out_success_file != "") && ($request->book_out_success_file != 'null')){
            $file_name_success = $code.'-'.$year.'-'.$request->book_out_success_file->getClientOriginalName();
            $path_success_file = '/document/book-out/'.$year.'/success/'.$file_name_success;
            Storage::disk('public')->put($path_success_file, file_get_contents($request->book_out_success_file));
            // Count Page
            // $pdftext = file_get_contents($book_out_success_file);
            // $book_page_count = preg_match_all("/\/Page\W/", $pdftext, $dummy);
        }else{
            $path_success_file = $data->book_out_success_file;
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
        $data->book_out_category_id = $request->book_out_category_id;
        $data->receive_date = $request->receive_date == 'null' ? null : $request->receive_date;
        $data->return_date = $request->return_date == 'null' ? null : $request->return_date;
        $data->book_no = $request->book_no;
        $data->book_date = $request->book_date == 'null' ? null : $request->book_date;
        $data->to_send = $request->to_send;
        $data->book_out_file = $path_file;
        $data->book_out_success_file = $path_success_file;
        $data->department_id = $request->department_id == 'null' ? null : $request->department_id;
        $data->book_to = $request->book_to == 'null' ? null : $request->book_to;
        $data->book_reference = $request->book_reference;
        $data->book_year_id = $book_year->id;
        $data->remark = $request->remark;
        $data->user_id = $request->user_id;
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
        $data = BookOut::where('id', $id)->first();

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
            $book_year = BookYear::where('id', $request->book_year_id)->first();

        }else{
            $book_year = BookYear::where('status', 1)->first();

        }

        $data = BookOut::where('deleted_at', null)
            ->where('book_out_category_id', $request->book_out_category_id)
            ->where('book_year_id', $book_year->id)
            ->whereNotNull('book_no')
            ->orderBy('book_no', 'desc')
            ->first();

        $code_latest = "";
        $code_next = "";
        if($data){

            $code_latest = $data->book_no;
            $code = explode("/", $code_latest);
            $code_next = floor(intval($code[0]))+1;
            
            $count = strlen($code_next);
            if($request->book_out_category_id == 1){
                $code_next = (string)$code_next;

                for($count; $count<4; $count++){
                    
                    $code_next = "0".$code_next;
                }
            }else if($request->book_out_category_id == 2){
                $code_next = (string)$code_next;
                for($count; $count<2; $count++){
                    $code_next = "0".$code_next;
                }
            }else if($request->book_out_category_id == 3){
                $code_next = (string)$code_next;
                for($count; $count<3; $count++){
                    $code_next = "0".$code_next;
                }
            }else{
                $code_next = (string)$code_next;
                for($count; $count<2; $count++){
                    $code_next = "0".$code_next;
                }
            }
            $code_next = $code_next.'/'.$code[1];
        }else{
            $cl = '';
            if($request->book_out_category_id == 1){
                $cl = '000/';
                $cn = '001/'; 
            }else if($request->book_out_category_id == 2){
                $cl = '00/';
                $cn = '01/';
            }else if($request->book_out_category_id == 3){
                $cl = '0000/';
                $cn = '0001/';
            }else{
                $cl = '00/';
                $cn = '01/';
            }
            $code_lastest = $cl.$book_year->name;
            $code_next = $cn.$book_year->name;
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
        $template = 'bookOutSend';

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
            ไฟล์เอกสาร: <a href="'.$this->uploadUrl.$data-out_file.'">เปิดไฟล์</a>'
        ];

         // ไฟล์เอกสาร: <a href="'.env('APP_URL').'http://edoc.fba.kmutnb.ac.th/storage'.$data->file.'">เปิดไฟล์</a>'
        // ไฟล์เอกสาร: <a href="'.env('APP_URL').'storage'.$data->file.'">เปิดไฟล์</a>'
        // var_dump($data->file);
        $file1 = public_path($data->book_out_file);

        try {
            // \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->file), $details, function($message)use($details , $data, $file1, $email) {
            //     $message->to($email)->subject($data->title)->attach($file1);
            // });
            \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->book_out_file));
        } catch (Throwable $e) {
            $sendmail = false;
        }
    }
}
