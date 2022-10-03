<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookStatus;
use Validator;
use Illuminate\Support\Facades\DB;

class BookStatusController extends Controller
{
    public function getAll()
    {
        // User DB
        $data = BookStatus::select(
                'id as id',
                'title as title',
                'level as level',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('active', 1)
            ->get();
        
        return response()->json([
            'message' => 'success',
            'status' => $data,
        ], 200);
    }
    public function get($id)
    {
        // User DB
        $data = BookStatus::select(
                'id as id',
                'title as title',
                'level as level',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'status' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required',
        ]);

        $title = $request->title;

        $data = new BookStatus;
        $data->title = $title;
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
        ]);

        $id = $request->id;
        $title = $request->title;

        $data = BookStatus::where('id',$id)->first();
        $data->title = $title;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookStatus::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
