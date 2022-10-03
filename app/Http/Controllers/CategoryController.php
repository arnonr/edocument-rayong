<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookCategory;
use Validator;
use Illuminate\Support\Facades\DB;

class CategoryController extends Controller
{
    public function getAll()
    {
        // User DB
        $data = BookCategory::select(
                'id as id',
                'title as title',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('active', 1)
            ->get();
        
        return response()->json([
            'message' => 'success',
            'category' => $data,
        ], 200);
    }

    public function get($id)
    {
        // User DB
        $data = BookCategory::select(
                'book_category.id as id',
                'book_category.title as title',
                'book_category.created_at as createdAt',
                'book_category.updated_at as updatedAt',
            )
            ->where('book_category.id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'bookCategory' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'title' => 'required',
            // 'year' => 'required',
            // 'level' => 'required'
        ]);

        $title = $request->title;

        $data = new BookCategory;
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

        $data = BookCategory::where('id', $id)->first();
        $data->title = $title;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = BookCategory::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
