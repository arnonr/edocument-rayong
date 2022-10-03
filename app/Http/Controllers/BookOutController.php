<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookOut;
use App\Models\BookCode;
use App\Models\BookType;
use App\Models\BookYear;
use App\Models\BookStatus;
use App\Models\User;
use Validator;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;

class BookOutController extends Controller
{
    public function get($id)
    {
        // User DB
        $data = BookOut::select(
            'book_out.id as id',
            'book_out.title as title',
            'book_out.user_id as userID',
            'book_type_id as bookTypeID',
            'book_type.title as bookTypeName',
            'book_type.acronym as bookTypeAcronym',
            'book_no as bookNo',
            'book_to as bookTo',
            'status_id as statusID',
            'book_status.title as statusTitle',
            'book_status.color as statusColor',
            'book_out.dep_id as departmentID',
            'department.name as departmentName',
            'file as file',
            'file_success as fileSuccess',
            'detail as detail',
            'date_send as dateSend',
            'to_send as toSend',
            'date_receive as dateReceive',
            'date_return as dateReturn',
            'book_out.created_at as createdAt',
            'book_out.updated_at as updatedAt',
            'book_out.active as active',
            'users.firstname as firstname',
            'users.lastname as lastname',
            'users.prefix as prefix',
            'book_out_favorite.id as bookOutFavoriteID'
        )
        ->where('book_out.active', 1)
        ->where('book_out.id', $id)
        ->leftJoin('book_type','book_out.book_type_id','=','book_type.id')
        ->leftJoin('department','book_out.dep_id','=','department.id')
        ->leftJoin('users','book_out.user_id','=','users.id')
        ->leftJoin('book_status','book_out.status_id','=','book_status.id')
        ->leftJoin('book_out_favorite','book_out.id','=','book_out_favorite.book_id')
        ->first();
        
        return response()->json([
            'message' => 'success',
            'bookOut' => $data,
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

        $data = BookOut::select(
            'book_out.id as id',
            'book_out.title as title',
            'book_out.user_id as userID',
            'book_type_id as bookTypeID',
            'book_type.title as bookTypeName',
            'book_no as bookNo',
            'book_to as bookTo',
            'status_id as statusID',
            'book_status.title as statusTitle',
            'book_status.color as statusColor',
            'book_out.dep_id as departmentID',
            'department.name as departmentName',
            'file as file',
            'file_success as fileSuccess',
            'detail as detail',
            'date_send as dateSend',
            'to_send as toSend',
            'date_receive as dateReceive',
            'date_return as dateReturn',
            'book_out.created_at as createdAt',
            'book_out.updated_at as updatedAt',
            'book_out.active as active',
            'users.firstname as firstname',
            'users.lastname as lastname',
            'users.prefix as prefix',
            'book_out_favorite.id as bookOutFavoriteID',
        )
        ->where('book_out.active', 1)
        ->where('book_out.book_year_id', $bookYear->id)
        ->leftJoin('book_type','book_out.book_type_id','=','book_type.id')
        ->leftJoin('department','book_out.dep_id','=','department.id')
        ->leftJoin('users','book_out.user_id','=','users.id')
        ->leftJoin('book_status','book_out.status_id','=','book_status.id')
        ->leftJoin('book_out_favorite','book_out.id','=','book_out_favorite.book_id')
        ->orderBy('date_send','desc')
        ->orderBy('id','desc')
        ->get();
        
        return response()->json([
            'message' => 'success',
            'bookOut' => $data,
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

        $data = BookOut::select(
            'book_out.id as id',
            'book_out.title as title',
            'book_out.user_id as userID',
            'book_type_id as bookTypeID',
            'book_type.title as bookTypeName',
            'book_no as bookNo',
            'book_to as bookTo',
            'status_id as statusID',
            'book_status.title as statusTitle',
            'book_status.color as statusColor',
            'book_out.dep_id as departmentID',
            'department.name as departmentName',
            'file as file',
            'file_success as fileSuccess',
            'detail as detail',
            'date_send as dateSend',
            'to_send as toSend',
            'date_receive as dateReceive',
            'date_return as dateReturn',
            'book_out.created_at as createdAt',
            'book_out.updated_at as updatedAt',
            'book_out.active as active',
            'users.firstname as firstname',
            'users.lastname as lastname',
            'users.prefix as prefix',
            'book_out_favorite.id as bookOutFavoriteID',
            'book_out.book_page_count_sum as bookPageCountSum'
        )
        ->where('book_out.active', 1)
        ->where('book_out.book_year_id', $bookYear->id)
        ->leftJoin('book_type','book_out.book_type_id','=','book_type.id')
        ->leftJoin('department','book_out.dep_id','=','department.id')
        ->leftJoin('users','book_out.user_id','=','users.id')
        ->leftJoin('book_status','book_out.status_id','=','book_status.id')
        ->leftJoin('book_out_favorite','book_out.id','=','book_out_favorite.book_id')
        ->orderBy('date_send','desc')
        ->orderBy('id','desc')
        ->get();
        
        return response()->json([
            'message' => 'success',
            'bookOut' => $data,
        ], 200);
    }
    
    public function add(Request $request)
    {
        $request->validate([
            'bookTypeID' => 'required',
            'dateSend' => 'required',
            'toSend' => 'required',
            'bookNo' => 'required',
            'title' => 'required',
            'departmentID' => 'required',
            'userID' => 'required',
            // 'detail' => 'string',
            'file' => 'required',
            // 'statusID' => 'required',
            // 'bookTo' => 'string',
            // 'file_success' => 'required',
            // 'dateReceive' => 'required',
            // 'dateReturn' => 'required',
        ]);

        $bookTypeID = $request->bookTypeID;
        $dateSend = $request->dateSend;
        $toSend = $request->toSend;
        $bookNo = $request->bookNo;
        $title = $request->title;
        $departmentID = $request->departmentID;
        $userID = $request->userID;
        $detail = $request->detail;
        $file = $request->file;
        $fileSuccess = $request->fileSuccess;
        $dateReceive = $request->dateReceive;
        $dateReturn = $request->dateReturn;
        $bookTo = $request->bookTo;
        $statusID = $request->statusID;

        // Check Book No.
        $bookOut = BookOut::where('active', 1)
            ->where('book_no', $bookNo)
            ->where('active',1)
            ->first();

        $bookNoChange = str_replace("/","-",$bookNo);
        $bookNoChangeExplode = explode("-", $bookNoChange);
        $year = $bookNoChangeExplode[1];
        $no = $bookNoChangeExplode[0];
        
        $bookType = BookType::where('id', $bookTypeID)->where('active', 1)->first();

        if($bookOut){
            // error
            return response()->json([
                'message' => 'error Duplicate Book No',
                'bookType' => $bookType
            ], 200);
        }

        // Save File
        $bookPageCount = 1;
        if($file != ""){
            $fileName = $bookNoChange.'-'.$request->file->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $path = '/document/book-out/'.$year.'/'.$fileName;
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
            $pathSuccess = '/document/book-out/'.$year.'/success/'.$fileNameSuccess;
            Storage::disk('public')->put($pathSuccess, file_get_contents($fileSuccess));
        }

        // Save DB
        $data = new BookOut;
        $data->title = $title;
        $data->user_id = $userID;
        $data->book_type_id = $bookTypeID;
        $data->book_no = $bookNo;
        $data->to_send = $toSend;
        $data->book_to = ($bookTo == 'null') ? null : $bookTo;
        $data->status_id = ($statusID != "undefined") ? $statusID:1;
        $data->dep_id = ($departmentID == 'null') ? null : $departmentID;
        $data->file = $path;
        $data->file_success = $pathSuccess;
        $data->detail = $detail;
        $data->date_send = $dateSend;
        $data->book_year_id = $bookType->year;
        $data->book_page_count = $bookPageCount;
        // $data->date_receive = $dateReceive;
        // $data->date_return = $dateReturn;
        $data->save();

        // Update Book Code Table
        $no = str_replace($bookType->acronym,"",$no);
        $bookType->code = (intval($no) < $bookType->code) ? $bookType->code : intval($no);
        $bookType->save();

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

        $dateSend = Carbon::parse($data->date_send);
        $month = $thai_months[$dateSend->month];
        $year = $dateSend->year + 543;
        $dateSend = $dateSend->format("j $month $year");

        $file = $data->file;
        if($data->file_success != null){
            $file = $data->file_success;
        }

        $details = [
            'title' => $data->title,
            'body' => '
            เรื่อง : '.$data->title.'<br>
            ถึง : '.$data->to_send.'<br>
            ลงวันที่ : '.$dateSend.'<br>
            ไฟล์เอกสาร: <a href="http://edoc.fba.kmutnb.ac.th/storage'.$file.'">เปิดไฟล์</a>'
        ];
        // ไฟล์เอกสาร: <a href="'.env('APP_URL').'storage'.$file.'">เปิดไฟล์</a>'

        // $file1 = public_path($file);
        // $files = env('APP_URL').'storage'.$file

        try {
            \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template, $data->file_success));
            // ->attach($file1);
        } catch (Throwable $e) {
            $sendmail = false;
        }
    }

    public function sendMailToUser($email, $data){
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

        $dateSend = Carbon::parse($data->date_send);
        $month = $thai_months[$dateSend->month];
        $year = $dateSend->year + 543;
        $dateSend = $dateSend->format("j $month $year");

        $details = [
            'title' => 'แจ้งกดรับหนังสือ : '.$data->title,
            'body' => 'เรื่อง : '.$data->title.'<br>
            ถึง : '.$data->to_send.'<br>
            ลงวันที่ : '.$dateSend.'<br>
            โปรดกดรับหนังสือในระบบ: <a href="'.env('APP_URL').'">www.cwiekmutnb.com</a><br>
            ไฟล์ฉบับสมบูรณ์: <a href="'.env('APP_URL').'/storage/'.$data->file_success.'">เปิดไฟล์</a>'
            
        ];

        try {
            \Mail::to($email)->send(new \App\Mail\MyMail($details, $data->title, $template));
        } catch (Throwable $e) {
            $sendmail = false;
        }
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'bookTypeID' => 'required',
            'dateSend' => 'required',
            'bookNo' => 'required',
            'toSend' => 'required',
            'title' => 'required',
            'departmentID' => 'required',
            'userID' => 'required',
            'detail' => 'string',
            'file' => 'required',
            // 'statusID' => 'required',
            // 'bookTo' => 'string',
            // 'file_success' => 'required',
            // 'dateReceive' => 'required',
            // 'dateReturn' => 'required',
        ]);

        $id = $request->id;
        $bookTypeID = $request->bookTypeID;
        $dateSend = $request->dateSend;
        $bookNo = $request->bookNo;
        $toSend = $request->toSend;
        $title = $request->title;
        $departmentID = $request->departmentID;
        $userID = $request->userID;
        $detail = $request->detail;
        $file = $request->file;
        $fileSuccess = $request->fileSuccess;
        $dateReceive = $request->dateReceive;
        $dateReturn = $request->dateReturn;
        $bookTo = $request->bookTo;
        $statusID = $request->statusID;
        $isSendEmail = $request->isSendEmail;

        // Check Book No.
        $bookOut = BookOut::where('active', 1)
            ->where('book_no', $bookNo)
            ->where('id','!=',$id)
            ->where('active',1)
            ->first();

        $bookNoChange = str_replace("/","-",$bookNo);
        $bookNoChangeExplode = explode("-", $bookNoChange);
        $year = $bookNoChangeExplode[1];
        $no = $bookNoChangeExplode[0];

        $bookType = BookType::where('id', $bookTypeID)->where('active', 1)->first();

        if($bookOut){
            // error
            return response()->json([
                'message' => 'error Duplicate Book No',
                'bookType' => $bookType
            ], 200);
        }

        $data = BookOut::where('id',$id)->first();

        // Save File
        if(($file != "") && ($file != 'null')){
            $fileName = $bookNoChange.'-'.$request->file->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $path = '/document/book-out/'.$year.'/'.$fileName;
            Storage::disk('public')->put($path, file_get_contents($file));
        }else{
            $path = $data->file;
        }

        // Save File Success
        $pathSuccess = null;
        if(($fileSuccess != "") && ($fileSuccess != 'null')){
            $fileNameSuccess = $bookNoChange.'-'.$request->fileSuccess->getClientOriginalName();
            // $fileName = $bookNoChange.'.'.$request->file->getClientOriginalExtension();
            $pathSuccess = '/document/book-out/'.$year.'/success/'.$fileNameSuccess;
            Storage::disk('public')->put($pathSuccess, file_get_contents($fileSuccess));
        }else{
            $pathSuccess = $data->file_success;
        }

        // Save DB
        $sendMailToUser = false;
        if(($data->status_id != 3) && ($statusID == 3)) {
            $sendMailToUser = true;
        }


        $data->title = $title;
        $data->user_id = $userID;
        $data->book_type_id = $bookTypeID;
        $data->book_no = $bookNo;
        $data->to_send = $toSend;
        $data->book_to = ($bookTo == 'null') ? null : $bookTo;
        $data->status_id = ($statusID != "undefined") ? $statusID: 1;
        $data->dep_id = ($departmentID == 'null') ? null : $departmentID;
        $data->file = $path;
        $data->file_success = $pathSuccess;
        $data->detail = $detail;
        $data->date_send = $dateSend;
        // $data->book_year_id = $bookType->year;
        // $data->date_receive = $dateReceive;
        // $data->date_return = $dateReturn;
        $data->save();

        // Update Book Code Table
        $no = str_replace($bookType->acronym, "", $no);
        $bookType->code = (intval($no) < $bookType->code) ? $bookType->code : intval($no);
        $bookType->save();

        // Sendmail
        if($isSendEmail == 'true'){
            if($bookTo != 'null'){
                foreach(json_decode($bookTo, true) as $key => $value){
                    $this->sendMail($value['email'], $data);
                }
            }
        }   

        if($sendMailToUser == true){
            $user = User::where('id', $data->user_id)->first();
            $this->sendMailToUser($user->email, $data);
        }

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookOut::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }

    public function changeStatus(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'statusID' => 'required',
        ]);

        $id = $request->id;
        $statusID = $request->statusID;

        // Check Book No.
        $bookOut = BookOut::where('id', $id)
            ->first();

        if($statusID == 2){
            $bookOut->date_receive = Carbon::now();
        }

        if($statusID == 4){
            $bookOut->date_return = Carbon::now();
        }

        $bookOut->status_id = $statusID;
        $bookOut->save();

        $bookStatus = BookStatus::select(
            'id as id',
            'title as title',
            'color as color',
            'level as level',
            'created_at as createdAt',
            'updated_at as updatedAt',
        )
        ->where('id', $statusID)
        ->first();

        if($statusID == 4){

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
            
            $dateSend = Carbon::parse($bookOut->date_send);
            $month = $thai_months[$dateSend->month];
            $year = $dateSend->year + 543;
            $dateSend = $dateSend->format("j $month $year");
    
            $details = [
                'title' => 'แจ้งเอกสารได้รับการอนุมัติ : '.$bookOut->title,
                'body' => '
                เรื่อง : '.$bookOut->title.'<br>
                ถึง : '.$bookOut->to_send.'<br>
                ลงวันที่ : '.$dateSend.'<br>
                ไฟล์เอกสาร: <a href="http://edoc.fba.kmutnb.ac.th/storage/'.$bookOut->file_success.'">เปิดไฟล์</a><br>
                กรุณากดรับเอกสารในระบบ: http://edoc.fba.kmutnb.ac.th/ <br>'
            ];
            
            // $bookOut->user_id
            // try {
            //     $user = User::find()->where('id',$bookOut->user_id)->first();
            //     \Mail::to($user->email)->send(new \App\Mail\MyMail($details, $bookOut->title, $template));
            // } catch (Throwable $e) {
            //     $sendmail = false;
            // }
        }

        $responseData = [
            'message' => 'success',
            'status' => $bookStatus,
            'dateReceive' => $bookOut->date_receive,
            'dateReturn' => $bookOut->date_return,
        ];
        
        return response()->json($responseData, 200);
    }
}
