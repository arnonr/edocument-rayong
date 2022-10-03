<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookYear;
use Validator;
use Illuminate\Support\Facades\DB;

class BookYearController extends Controller
{
    public function getAll()
    {
        // User DB
        $data = BookYear::select(
                'id as id',
                'title as title',
                'status as status',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('active', 1)
            ->orderBy('title','DESC')
            ->get();
        
        return response()->json([
            'message' => 'success',
            'bookYear' => $data,
        ], 200);
    }

    public function get($id)
    {
        // User DB
        $data = BookYear::select(
                'id as id',
                'title as title',
                'status as status',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'bookYear' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title as required',
            // 'level' => 'required'
        ]);

        $title = $request->title;
        $status = $request->status;

        if($status == 1){
            $data = BookYear::where('status',1)->update(['status' => 0]);
        }

        $data = new BookYear;
        $data->title = $title;
        $data->status = $status;
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
            'status' => 'required',
        ]);

        $id = $request->id;
        $title = $request->title;
        $status = $request->status;

        if($status == 1){
            $data = BookYear::where('status',1)->update(['status' => 0]);
        }

        $data = BookYear::where('id', $id)->first();
        $data->title = $title;
        $data->status = $status;
        $data->save();

        

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookYear::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
