<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookCode;
use Validator;
use Illuminate\Support\Facades\DB;

class BookCodeController extends Controller
{
    public function getActive()
    {
        // User DB
        $data = BookCode::select(
                'book_code.id as id',
                'book_code.book_in as bookIn',
                'book_code.book_out as bookOut',
                'book_year.title as year',
                'book_code.year as yearID',
                'book_code.created_at as createdAt',
                'book_code.updated_at as updatedAt',
            )
            ->where('book_code.status', 1)
            ->where('book_code.active', 1)
            ->join('book_year','book_year.id','=','book_code.year')
            ->first();
        
        return response()->json([
            'message' => 'success',
            'code' => $data,
        ], 200);
    }

    public function getWithYear($yearID)
    {
        // User DB
        $data = BookCode::select(
                'book_code.id as id',
                'book_code.book_in as bookIn',
                'book_code.book_out as bookOut',
                'book_year.title as year',
                'book_code.year as yearID',
                'book_code.created_at as createdAt',
                'book_code.updated_at as updatedAt',
            )
            ->where('book_code.year', $yearID)
            ->join('book_year','book_year.id','=','book_code.year')
            ->first();
        
        return response()->json([
            'message' => 'success',
            'code' => $data,
        ], 200);
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'bookIn' => 'required',
            'year' => 'required',
        ]);

        $id = $request->id;
        $bookIn = $request->bookIn;
        $year = $request->year;

        $data = BookCode::where('id', $id)->first();
        $data->book_in = $bookIn;
        $data->year = $year;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }
}
