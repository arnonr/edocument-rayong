<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\EmailPerson;
use Validator;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class EmailPersonController extends Controller
{
    public function getAll(Request $request)
    {
        
        $data = EmailPerson::select(
            'id as id',
            'prefix as prefix',
            'firstname as firstname',
            'lastname as lastname',
            'email as email',
            'is_publish as is_publish',
            'deleted_at as delete_at',
            'created_at as created_at',
            'created_by as created_by',
            'updated_at as updated_at',
            'updated_by as updated_by',
        )
        ->where('deleted_at', null);
        
        if ($request->id) {
            $data->where('id',$request->id);
        }

        if ($request->name) {
            $data->where('firstname','LIKE',"%".$request->firstname."%");
        }

        if ($request->name) {
            $data->where('lastname','LIKE',"%".$request->lastname."%");
        }

        if ($request->email) {
            $data->where('email','LIKE',"%".$request->email."%");
        }

        if ($request->is_publish) {
            $data->where('is_publish',$request->is_publish);
        }

        $order_by = $request->order_by ? $request->order_by : 'id';
        $order = $request->order ? $request->order : 'asc';

        $data = $data->orderBy($order_by, $order);
            
        $data = $data->get();

        return response()->json([
            'message' => 'success',
            'data' => $data,
        ], 200);
    }

    public function get($id)
    {
        // User DB
        $data = EmailPerson::select(
            'id as id',
            'prefix as prefix',
            'firstname as firstname',
            'lastname as lastname',
            'email as email',
            'is_publish as is_publish',
            'deleted_at as delete_at',
            'created_at as created_at',
            'created_by as created_by',
            'updated_at as updated_at',
            'updated_by as updated_by',
        )
        ->where('id', $id)
        ->first();
        
        return response()->json([
            'message' => 'success',
            'data' => $data,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'firstname as required',
        ]);

        $data = new EmailPerson;
        $data->prefix = $request->prefix;
        $data->firstname = $request->firstname;
        $data->lastname = $request->lastname;
        $data->email = $request->email;
        $data->is_publish = $request->is_publish;
        $data->created_by = 'arnonr';
        $data->save();

        $responseData = [
            'message' => 'success',
            'data' => $data,
        ];
        
        return response()->json($responseData, 200);
    }

    public function edit($id, Request $request)
    {
        $request->validate([
            'id as required',
            'firstname as required',
        ]);

        $id = $request->id;
        // $name = $request->name;

        $data = EmailPerson::where('id', $id)->first();

        $data->prefix = $request->prefix;
        $data->firstname = $request->firstname;
        $data->lastname = $request->lastname;
        $data->email = $request->email;
        $data->is_publish = $request->is_publish;
        $data->updated_by = 'arnonr';
        $data->save();

        $responseData = [
            'message' => 'success',
            'data' => $data,
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = EmailPerson::where('id', $id)->first();

        $data->deleted_at = Carbon::now();
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
