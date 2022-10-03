<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookIn;
use App\Models\BookCode;
use App\Models\BookYear;
use Validator;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;

class BookInController extends Controller
{
    public function get($id)
    {
        // User DB
        $data = BookIn::select(
            'book_in.id as id',
            'book_in.title as title',
            'book_no as bookNo',
            'category_id as categoryID',
            'book_category.title as categoryName',
            'department.name as departmentName',
            'book_from_no as bookFromNo',
            'book_from_date as bookFromDate',
            'book_from as bookFrom',
            'file as file',
            'file_success as fileSuccess',
            'detail as detail',
            'date_receive as dateReceive',
            'dep_to as departmentTo',
            'book_to as bookTo',
            'book_reference as bookReference',
            'status as status',
            'book_in.created_at as createdAt',
            'book_in.updated_at as updatedAt',
            'book_favorite.id as bookFavoriteID',
            'book_in.to_send as toSend',
            'book_in.book_year_id as bookYearID'
        )
        ->where('book_in.active', 1)
        ->where('book_in.id', $id)
        ->leftJoin('book_category','book_in.category_id','=','book_category.id')
        ->leftJoin('department','book_in.dep_to','=','department.id')
        ->leftJoin('book_favorite','book_favorite.book_id','=','book_in.id')
        ->first();
        
        return response()->json([
            'message' => 'success',
            'bookIn' => $data,
        ], 200);
    }
    public function getAll()
    {
        // User DB
        if(isset($request->year_id)){
            $bookYear = BookYear::where('id', $request->year_id)->first();
        }else{
            $bookYear = BookYear::where('status', 1)->first();
        }

        $data = BookIn::select(
                'book_in.id as id',
                'book_in.title as title',
                'book_no as bookNo',
                'category_id as categoryID',
                'book_category.title as categoryName',
                'department.name as departmentName',
                'book_from_no as bookFromNo',
                'book_from_date as bookFromDate',
                'book_from as bookFrom',
                'file as file',
                'file_success as fileSuccess',
                'detail as detail',
                'date_receive as dateReceive',
                'dep_to as departmentTo',
                'book_to as bookTo',
                'book_reference as bookReference',
                'status as status',
                'book_in.created_at as createdAt',
                'book_in.updated_at as updatedAt',
                'book_favorite.id as bookFavoriteID',
                'book_in.to_send as toSend',
            )
            ->where('book_in.active', 1)
            ->where('book_in.book_year_id', $bookYear->id)
            ->leftJoin('book_category','book_in.category_id','=','book_category.id')
            ->leftJoin('department','book_in.dep_to','=','department.id')
            ->leftJoin('book_favorite','book_favorite.book_id','=','book_in.id')
            ->orderBy('date_receive','DESC')
            ->get();
        
        return response()->json([
            'message' => 'success',
            'bookIn' => $data,
        ], 200);
    }

    public function getWithYear($id)
    {
        // User DB
        if(isset($id)){
            $bookYear = BookYear::where('id', $id)->first();
        }else{
            $bookYear = BookYear::where('status', 1)->first();
        }

        $data = BookIn::select(
                'book_in.id as id',
                'book_in.title as title',
                'book_no as bookNo',
                'category_id as categoryID',
                'book_category.title as categoryName',
                'department.name as departmentName',
                'book_from_no as bookFromNo',
                'book_from_date as bookFromDate',
                'book_from as bookFrom',
                'file as file',
                'detail as detail',
                'date_receive as dateReceive',
                'dep_to as departmentTo',
                'book_to as bookTo',
                'book_reference as bookReference',
                'status as status',
                'book_in.created_at as createdAt',
                'book_in.updated_at as updatedAt',
                'book_favorite.id as bookFavoriteID',
                'book_in.to_send as toSend',
                'book_in.book_page_count_sum as bookPageCountSum'
            )
            ->where('book_in.active', 1)
            ->where('book_in.book_year_id', $bookYear->id)
            ->leftJoin('book_category','book_in.category_id','=','book_category.id')
            ->leftJoin('department','book_in.dep_to','=','department.id')
            ->leftJoin('book_favorite','book_favorite.book_id','=','book_in.id')
            ->orderBy('date_receive','DESC')
            ->get();
        
        return response()->json([
            'message' => 'success',
            'bookIn' => $data,
        ], 200);
    }
    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'bookNo' => 'required',
            'categoryID' => 'required',
            'fromNo' => 'string',
            'fromDate' => 'date',
            'from' => 'string',
            'file' => 'required',
            // 'detail' => 'string',
            'dateReceive' => 'date',
            // 'departmentID' => 'nullable|integer',
            'toSend' => 'string',
            'bookTo' => 'string',
            // 'bookReference' => '' 
        ]);

        $title = $request->title;
        $bookNo = $request->bookNo;
        $categoryID = $request->categoryID;
        $fromNo = $request->fromNo;
        $fromDate = $request->fromDate;
        $bookFrom = $request->from;
        $file = $request->file;
        $fileSuccess = $request->fileSuccess;
        $detail = $request->detail;
        $dateReceive = $request->dateReceive;
        $departmentID = $request->departmentID;
        $bookTo = $request->bookTo;
        $toSend = $request->toSend;
        // $bookReference = $request->;

        // Check Book No.
        $bookIn = BookIn::where('active', 1)
            ->where('book_no', $bookNo)
            ->where('active',1)
            ->first();

        $bookNoChange = str_replace("/","-",$bookNo);
        $bookNoChangeExplode = explode("-", $bookNoChange);
        $year = $bookNoChangeExplode[1];
        $no = $bookNoChangeExplode[0];
        
        
        $bookYear = BookYear::where('status', 1)->where('active', 1)->first();
        if($bookYear->title != $year){
            $bookYear = BookYear::where('title', $year)->where('active', 1)->first();
        }
        $bookCode = BookCode::where('year', $bookYear->id)->where('active', 1)->first();

        if($bookIn){
            // error
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $bookCode
            ], 200);
        }

        $bookPageCount = 1;
        // Save File
        if($file != ""){
            $fileName = $bookNoChange.'-'.$request->file->getClientOriginalName();
            $path = '/document/book-in/'.$year.'/'.$fileName;
            Storage::disk('public')->put($path, file_get_contents($file));
            $pdftext = file_get_contents($file);
            $bookPageCount = preg_match_all("/\/Page\W/", $pdftext, $dummy);
            
        }else{
            return response()->json([
                'message' => 'error Not File Upload'
            ], 200);
        }

        // Save File Success
        $pathSuccess = null;
        if(($fileSuccess != "") && ($fileSuccess != 'null')){
            $fileNameSuccess = $bookNoChange.'-'.$request->fileSuccess->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $pathSuccess = '/document/book-in/'.$year.'/success/'.$fileNameSuccess;
            Storage::disk('public')->put($pathSuccess, file_get_contents($fileSuccess));
        }

        // Save DB
        $data = new BookIn;
        $data->title = $title;
        $data->book_no = $bookNo;
        $data->category_id = $categoryID;
        $data->book_from_no = $fromNo;
        $data->book_from_date = $fromDate;
        $data->book_from = $bookFrom;
        $data->file = $path;
        $data->file_success = $pathSuccess;
        $data->detail = $detail;
        $data->date_receive = $dateReceive;
        $data->dep_to = ($departmentID == 'null') ? null : $departmentID;
        $data->book_to = ($bookTo == 'null') ? null : $bookTo;
        $data->status = 1;
        $data->book_code_id = $bookCode->id;
        $data->to_send = $toSend;
        $data->book_year_id = $bookCode->year;
        $data->book_page_count = $bookPageCount;
        // $data->save();   

        // Update Book Code Table
        $bookCode->book_in = (intval($no) < $bookCode->book_in) ? $bookCode->book_in: intval($no);
        $bookCode->save();

        // Sendmail
        $countBookTo = 0;
        if($bookTo != 'null'){
            foreach(json_decode($bookTo, true) as $key => $value){
                $countBookTo++;
                $this->sendMail($value['email'], $data);
            }
        }

        if($countBookTo == 0){
            $countBookTo = 1;
        }

        $bookPageCountSum = $bookPageCount * $countBookTo;
        $data->book_page_count_sum = $bookPageCountSum;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

  

    public function sendMail($email, $data){
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

        $dateReceive = Carbon::parse($data->date_receive);
        $month = $thai_months[$dateReceive->month];
        $year = $dateReceive->year + 543;
        $dateReceive = $dateReceive->format("j $month $year");

        $details = [
            'title' => $data->title,
            'body' => '
            เรื่อง : '.$data->title.'<br>
            จาก : '.$data->book_from.'<br>
            วันที่รับ : '.$dateReceive.'<br>
            ไฟล์เอกสาร: <a href="http://edoc.fba.kmutnb.ac.th/storage'.$data->file.'">เปิดไฟล์</a>'
        ];

         // ไฟล์เอกสาร: <a href="'.env('APP_URL').'http://edoc.fba.kmutnb.ac.th/storage'.$data->file.'">เปิดไฟล์</a>'
        // ไฟล์เอกสาร: <a href="'.env('APP_URL').'storage'.$data->file.'">เปิดไฟล์</a>'
        // var_dump($data->file);
        $file1 = public_path($data->file);

        try {
            // \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->file), $details, function($message)use($details , $data, $file1, $email) {
            //     $message->to($email)->subject($data->title)->attach($file1);
            // });
            \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->file));
        } catch (Throwable $e) {
            $sendmail = false;
        }
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'title' => 'required',
            'bookNo' => 'required',
            'categoryID' => 'required',
            'fromNo' => 'string',
            'fromDate' => 'date',
            'from' => 'string',
            'file' => 'required',
            'detail' => 'string',
            'dateReceive' => 'date',
            // 'departmentID' => 'nullable|integer',
            'bookTo' => 'string',
            'toSend' => 'string',
            // 'bookReference' => '' 
        ]);

        $id = $request->id;
        $title = $request->title;
        $bookNo = $request->bookNo;
        $bookYearID = $request->bookYearID;
        $categoryID = $request->categoryID;
        $fromNo = $request->fromNo;
        $fromDate = $request->fromDate;
        $bookFrom = $request->from;
        $file = $request->file;
        $fileSuccess = $request->fileSuccess;
        $detail = $request->detail;
        $dateReceive = $request->dateReceive;
        $departmentID = $request->departmentID;
        $bookTo = $request->bookTo;
        $isSendEmail = $request->isSendEmail;
        $toSend = $request->toSend;
        // $bookReference = $request->;

        // Check Book No.
        $bookIn = BookIn::where('active', 1)
            ->where('book_no', $bookNo)
            ->where('id','!=',$id)
            ->where('active',1)
            ->first();

        $bookNoChange = str_replace("/","-",$bookNo);
        $bookNoChangeExplode = explode("-", $bookNoChange);
        $year = $bookNoChangeExplode[1];
        $no = $bookNoChangeExplode[0];

        $bookCode = BookCode::where('year', $bookYearID)->where('active',1)->first();
        if($bookIn){
            // error
            return response()->json([
                'message' => 'error Duplicate Book No',
                'code' => $bookCode
            ], 200);
        }

        $data = BookIn::where('id',$id)->first();

        // Save File
        if(($file != "") && ($file != 'null')){
            $fileName = $bookNoChange.'-'.$request->file->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $path = '/document/book-in/'.$year.'/'.$fileName;
            Storage::disk('public')->put($path, file_get_contents($file));
        }else{
            $path = $data->file;
        }

        // Save File Success
        $pathSuccess = null;
        if(($fileSuccess != "") && ($fileSuccess != 'null')){
            $fileNameSuccess = $bookNoChange.'-'.$request->fileSuccess->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $pathSuccess = '/document/book-in/'.$year.'/success/'.$fileNameSuccess;
            Storage::disk('public')->put($pathSuccess, file_get_contents($fileSuccess));
        }else{
            $pathSuccess = $data->file_success;
        }

        // Save DB
        $data->title = $title;
        $data->book_no = $bookNo;
        $data->category_id = $categoryID;
        $data->book_from_no = $fromNo;
        $data->book_from_date = $fromDate;
        $data->book_from = $bookFrom;
        $data->file = $path;
        $data->file_success = $pathSuccess;
        $data->detail = $detail;
        $data->date_receive = $dateReceive;
        $data->dep_to = ($departmentID == 'null') ? null : $departmentID;
        $data->book_to = ($bookTo == 'null') ? null : $bookTo;
        $data->status = 1;
        $data->book_code_id = $bookCode->id;
        $data->to_send = $toSend;
        $data->save();

        // Update Book Code Table
        $bookCode->book_in = (intval($no) < $bookCode->book_in) ? $bookCode->book_in: intval($no);
        $bookCode->save();

        // Sendmail
        if($isSendEmail == 'true'){
            if($bookTo != 'null'){
                foreach(json_decode($bookTo, true) as $key => $value){
                    $this->sendMail($value['email'], $data);
                }
            }
        }   

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }


    public function delete($id)
    {
        $data = BookIn::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
