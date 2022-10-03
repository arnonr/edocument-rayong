<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Department;
use Validator;
use Illuminate\Support\Facades\DB;

class DepartmentController extends Controller
{
    public function getAll()
    {
        // User DB
        $data = Department::select(
                'id as id',
                'name as name',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('active', 1)
            ->get();
        
        return response()->json([
            'message' => 'success',
            'department' => $data,
        ], 200);
    }

    public function get($id)
    {
        // User DB
        $data = Department::select(
                'id as id',
                'name as name',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'department' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'name' => 'required',
        ]);

        $name = $request->name;

        $data = new Department;
        $data->name = $name;
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
            'name' => 'required',
        ]);

        $id = $request->id;
        $name = $request->name;

        $data = Department::where('id',$id)->first();
        $data->name = $name;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = Department::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
