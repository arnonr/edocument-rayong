<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\EmailPerson;
use App\Models\EmailGroup;
use Validator;
use Illuminate\Support\Facades\DB;

class EmailController extends Controller
{
    public function getAllPerson()
    {
        // User DB
        $data = EmailPerson::select(
                'id as id',
                'prefix as prefix',
                'firstname as firstname',
                'lastname as lastname',
                'email as email',
                'group_no as groupID',
                'created_at as createdAt',
                'updated_at as updatedAt',
                'active as active'
            )
            ->where('active', 1)
            ->get();
        
        return response()->json([
            'message' => 'success',
            'email' => $data,
        ], 200);
    }
    public function getPerson($id)
    {
        // User DB
        $data = EmailPerson::select(
                'id as id',
                'prefix as prefix',
                'firstname as firstname',
                'lastname as lastname',
                'email as email',
                'created_at as createdAt',
                'updated_at as updatedAt',
            )
            ->where('id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'emailPerson' => $data,
        ], 200);
    }

    public function addPerson(Request $request)
    {
        $request->validate([
            'firstname' => 'required',
            'lastname' => 'required',
            'email' => 'required',
        ]);

        $prefix = $request->prefix;
        $firstname = $request->firstname;
        $lastname = $request->lastname;
        $email = $request->email;

        $data = new EmailPerson;
        $data->prefix = $prefix;
        $data->firstname = $firstname;
        $data->lastname = $lastname;
        $data->email = $email;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function editPerson(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'firstname' => 'required',
            'lastname' => 'required',
            'email' => 'required',
        ]);

        $id = $request->id;
        $prefix = $request->prefix;
        $firstname = $request->firstname;
        $lastname = $request->lastname;
        $email = $request->email;

        $data = EmailPerson::where('id', $id)->first();
        $data->prefix = $prefix;
        $data->firstname = $firstname;
        $data->lastname = $lastname;
        $data->email = $email;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function deletePerson($id)
    {
        $data = EmailPerson::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }

    public function getAllGroup()
    {
        // User DB
        $data = EmailGroup::select(
                'id as id',
                'name as name',
                'email_all as emailAll',
                'created_at as createdAt',
                'updated_at as updatedAt',
                'active as active'
            )
            ->where('active', 1)
            ->get();
        
        return response()->json([
            'message' => 'success',
            'emailGroup' => $data,
        ], 200);
    }

    public function getGroup($id)
    {
            // User DB
            $data = EmailGroup::select(
                'id as id',
                'name as name',
                'email_all as emailAll',
                'created_at as createdAt',
                'updated_at as updatedAt',
                'active as active'
            )
            ->where('id', $id)
            ->first();
        
        return response()->json([
            'message' => 'success',
            'emailGroup' => $data,
        ], 200);
    }

    public function addGroup(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'emailAll' => 'required',
        ]);

        $name = $request->name;
        $emailAll = $request->emailAll;

        $data = new emailGroup;
        $data->name = $name;
        $data->email_all = $emailAll;
        $data->save(); 

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }
   

    public function editGroup(Request $request)
    {
        $request->validate([
            'id' => 'required',
            'name' => 'required',
            'emailAll' => 'required',
        ]);

        $id = $request->id;
        $name = $request->name;
        $emailAll = $request->emailAll;

        $data = emailGroup::where('id',$id)->first();
        $data->name = $name;
        $data->email_all = $emailAll;
        $data->save(); 

        $responseData = [
            'message' => 'success'
        ];
        
        return response()->json($responseData, 200);
    }

    public function deleteGroup($id)
    {
        $data = EmailGroup::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
