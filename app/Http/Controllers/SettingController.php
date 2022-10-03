<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Setting;
use Validator;
use Illuminate\Support\Facades\DB;

class SettingController extends Controller
{
    public function get()
    {
        // User DB
        $data = Setting::select(
                'id as id',
                'email as email',
                'password as password',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->first();
        
        return response()->json([
            'message' => 'success',
            'setting' => $data,
        ], 200);
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'email' => 'required',
            'password' => 'required',
        ]);

        $id = $request->id;
        $email = $request->email;
        $password = $request->password;

        $data = Setting::where('id', $id)->first();
        $data->email = $email;
        $data->password = $password;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }
}
