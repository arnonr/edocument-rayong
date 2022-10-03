<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookType;
use App\Models\BookYear;
use Validator;
use Illuminate\Support\Facades\DB;

class BookTypeController extends Controller
{
    public function getAll(Request $request)
    {
        $yearID = $request->yearID;
        // User DB
       
        if($yearID != null){
            $bookYear = BookYear::where('id',1)->first();
        }else{
            $bookYear = BookYear::where('status',1)->where('active',1)->first();
        }
        
        $data = BookType::select(
                'book_type.id as id',
                'book_type.title as title',
                'book_type.acronym as acronym',
                'book_type.code as code',
                'book_year.title as year',
                'book_type.created_at as createdAt',
                'book_type.updated_at as updatedAt',
            )
            ->where('book_type.active', 1)
            ->where('book_type.year',$bookYear->id)
            ->join('book_year','book_year.id','=','book_type.year')
            ->get();
        
        return response()->json([
            'message' => 'success',
            'bookType' => $data,
        ], 200);
    }

    public function get($id)
    {
        // User DB
        $data = BookType::select(
                'book_type.id as id',
                'book_type.title as title',
                'book_type.acronym as acronym',
                'book_type.code as code',
                'book_type.year as year',
                'book_year.title as yearTitle',
                'book_type.created_at as createdAt',
                'book_type.updated_at as updatedAt',
            )
            ->where('book_type.id', $id)
            ->join('book_year','book_year.id','=','book_type.year')
            ->first();
        
        return response()->json([
            'message' => 'success',
            'bookType' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'acronym' => 'required',
            'code' => 'required',
            // 'year' => 'required',
            // 'level' => 'required'
        ]);

        $title = $request->title;
        $acronym = $request->acronym;
        $code = $request->code;
        $year = $request->year;
        $level =$request->level;

        $bookYear = BookYear::where('status',1)->where('active',1)->first();

        $data = new BookType;
        $data->title = $title;
        $data->acronym = $acronym;
        $data->code = $code;
        $data->year = $bookYear->id;
        $data->level = $level;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'title' => 'required',
            'acronym' => 'required',
            'code' => 'required',
            'year' => 'required',
        ]);

        $id = $request->id;
        $title = $request->title;
        $acronym = $request->acronym;
        $code = $request->code;
        $year = $request->year;
        $level =$request->level;

        $data = BookType::where('id', $id)->first();
        $data->title = $title;
        $data->acronym = $acronym;
        $data->code = $code;
        $data->year = $year;
        $data->level = $level;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookType::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
