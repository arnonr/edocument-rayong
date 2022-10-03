<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Carbon\Carbon;
use Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;

class UserController extends Controller
{
    public function get($id)
    {
        // User DB
        $userDB = User::select(
                'users.id as id',
                'users.email as email',
                'users.username as username',
                'users.prefix as prefix',
                'users.firstname as firstname',
                'users.lastname as lastname',
                'users.type as type',
                'users.avatar as avatar',
                'users.status as status',
                'department.id as departmentID',
                'department.name as departmentName',
            )
            ->where('users.id', $id)
            ->leftJoin('department','users.dep_id', '=', 'department.id')
            ->first();

        $data = [
            'userID' => $userDB->id,
            'email' => $userDB->email ? $userDB->email : '',
            'prefix' => $userDB->prefix ? $userDB->prefix : '',
            'firstname' => $userDB->firstname,
            'lastname' => $userDB->lastname,
            'type' => $userDB->type,
            'status' => $userDB->status,
            'department' => [
                'id' => $userDB->departmentID ? $userDB->departmentID : '',
                'name' => $userDB->departmentName ? $userDB->departmentName : '-',
            ],
            'avatar' =>  $userDB->avatar ? $userDB->avatar : '',
        ];
        
        $tokenResult = $userDB->createToken('Personal Access Token');
        $token = $tokenResult->token;
 
        $token->expires_at = Carbon::now()->addWeeks(1);
        $token->save();

        $ability = [
            [
                'subject'=> 'Auth',
                'action'=> 'manage',
            ],
            [
                'subject'=> 'Auth',
                'action'=> 'read',
            ]
        ];

        if($userDB->status == 1){
            $role = 'wating-approve-user';

            array_push($ability, [
                'action' => 'manage',
                'subject'=> 'WatingApproveUser',
            ]);
        }else if($userDB->status == 2){

            array_push($ability, [
                'action' => 'manage',
                'subject'=> 'User',
            ]);

            if($userDB->type == 'staff'){
                $role = 'staff';
                array_push($ability, [
                    'action' => 'manage',
                    'subject'=> 'StaffUser',
                ]);
            }else if($userDB->type == 'admin'){
                $role = 'admin';
                array_push($ability, [
                    'action' => 'manage',
                    'subject'=> 'AdminUser',
                ]);
            }else{

            }
        }else if ($userDB->status == 3){
            $role = 'block';
            array_push($ability, [
                'action' => 'manage',
                'subject'=> 'BlockUser',
            ]);
        }else{

        }

        $userData = [
            'userID' => $userDB->id,
            'email' => $userDB->email,
            'username' => $userDB->username,
            'fullName' => $userDB->firstname.' '.$userDB->lastname,
            'avatar' => $userDB->avatar,
            'type' => $userDB->type,
            'status' => $userDB->status,
            'department' => ['id' => $userDB->departmentID,'name' => $userDB->departmentName],
            'role' => $role,
            'ability' => $ability,
        ];

        return response()->json([
            'message' => 'success',
            'user' => $data,
            'userData' => $userData,
            'accessToken' => $tokenResult->accessToken,
            'token_type' => 'Bearer',
            'expires_at' => Carbon::parse(
                $tokenResult->token->expires_at
            )->toDateTimeString()
        ], 200);
    }

    public function getAll()
    {
        // User DB
        $userDB = User::select(
                'users.id as userID',
                'users.email as email',
                'users.avatar as avatar',
                'users.prefix as prefix',
                'users.firstname as firstname',
                'users.lastname as lastname',
                'users.type as type',
                'users.status as status',
                'department.id as departmentID',
                'department.name as departmentName',
            )
            ->leftJoin('department', 'users.dep_id', '=', 'department.id')
            ->where('users.active',1)
            ->get();

        return response()->json([
            'message' => 'success',
            'user' => $userDB,
        ], 200);
    }

    public function edit(Request $request)
    {
        $request->validate([
            'id' => 'required',
        ]);

        $id = $request->id;
        $user = User::where('id', $id)->first();

        $user->prefix = ($request->has('prefix')) ? $request->prefix : $user->prefix;
        $user->firstname = ($request->has('firstname')) ? $request->firstname : $user->firstname;
        $user->lastname = ($request->has('lastname')) ? $request->lastname : $user->lastname;
        $user->email = ($request->has('email')) ? $request->email : $user->email;
        $user->dep_id = ($request->has('departmentID')) ? $request->departmentID : $user->dep_id;
        $user->status = ($request->has('status')) ? $request->status : $user->status;
        $user->type = ($request->has('type')) ? $request->type : $user->type;

        $user->save();

        $responseData = [
            'message' => 'success',
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = User::where('id', $id)->first();

        $data->active = 0;
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
