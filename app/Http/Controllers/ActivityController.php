<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mou;
use App\Models\Activity;
use Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;
const whitelist = ['127.0.0.1', "::1","localhost:8105"];

class ActivityController extends Controller
{
    protected $uploadUrl = "http://110.164.166.140/storage/";
    public function getAll(Request $request)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8105/storage/';
        }
        // User DB
        $items = Activity::select(
                'activity.id as id',
                'activity.name as name',
                'activity.detail as detail',
                'activity.start_date as start_date',
                'activity.end_date as end_date',
                DB::raw("(CASE WHEN activity_file = NULL THEN NULL
                    ELSE CONCAT('".$this->uploadUrl."',activity_file) END) AS activity_file"),
                'activity.mou_id as mou_id',
            )
            ->where('activity.deleted_at', null);

        if ($request->id) {
            $items->where('activity.id', $request->id);
        }

        if ($request->name) {
            $items->where('activity.name','LIKE',"%".$request->name."%");
        }

        if ($request->mou_id) {
            $items->where('activity.mou_id',$request->mou_id);
        }

        if ($request->is_publish != null) {
            $items->where('mou.is_publish', $request->is_publish);
        }

        if($request->orderBy){
            $items = $items->orderBy($request->orderBy, $request->order);
            
        }else{
            $items = $items->orderBy('id', 'desc');
        }

        $count = $items->count();
        $perPage = $request->perPage ? $request->perPage : 100;
        $currentPage = $request->currentPage ? $request->currentPage : 1;

        $totalPage = ceil($count /$perPage) == 0 ? 1 : ceil($count / $perPage);
        $offset = $perPage * ($currentPage - 1);
        $items = $items->skip($offset)->take($perPage);
        $items = $items->get();

        return response()->json([
            'message' => 'success',
            'data' => $items,
            'totalPage' => $totalPage,
            'totalData' => $count,
        ], 200);
    }

    public function get($id)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8105/storage/';
        }
        // User DB
        $items = Activity::select(
            'activity.id as id',
            'activity.name as name',
            'activity.start_date as start_date',
            'activity.end_date as end_date',
            'activity.detail as detail',
            DB::raw("(CASE WHEN activity_file = NULL THEN NULL
                ELSE CONCAT('".$this->uploadUrl."',activity_file) END) AS activity_file"),
            'activity.mou_id as mou_id',
        )->where('activity.deleted_at', null)
        ->first();
        
        return response()->json([
            'message' => 'success',
            'data' => $item,
        ], 200);
    }

    public function add(Request $request)
    {
        $request->validate([
            'name as required',
            'mou_id as required',
            'is_publish as required',
        ]);

        $pathActivity = null;
        if(($request->activity_file != "") && ($request->activity_file != 'null')){
            $fileNameActivity = 'activity-'.rand(10,100).'-'.$request->activity_file->getClientOriginalName();
            $pathActivity = '/activity/'.$fileNameActivity;
            Storage::disk('public')->put($pathActivity, file_get_contents($request->activity_file));
        }

        $data = new Activity;
        $data->name = $request->name;
        $data->detail = $request->detail;
        $data->start_date = $request->start_date;
        $data->end_date = $request->end_date;
        $data->activity_file = $pathActivity;
        $data->mou_id = $request->mou_id;
        $data->is_publish = 1;
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
            'name as required',
            'mou_id as required',
            'is_publish as required',
        ]);
        
        $data = Activity::where('id',$id)->first();

        // Save File Success
        $pathActivity = null;

        if(($request->activity_file != "") && ($request->activity_file != 'null')){
            $fileNameActivity = 'activity-'.rand(10,100).'-'.$request->activity_file->getClientOriginalName();
            $pathActivity = '/activity/'.$fileNameActivity;
            Storage::disk('public')->put($pathActivity, file_get_contents($request->activity_file));
        }else{
            $pathActivity = $data->activity_file;
        }

        $data->name = $request->name;
        $data->detail = $request->detail;
        $data->start_date = $request->start_date;
        $data->end_date = $request->end_date;
        $data->activity_file = $pathActivity;
        $data->mou_id = $request->mou_id;
        $data->is_publish = 1;
        $data->created_by = 'arnonr';
        $data->save();

        $responseData = [
            'message' => 'success',
            'data' => $data,
        ];
        
        return response()->json($responseData, 200);
    }

    public function delete($id)
    {
        $data = Activity::where('id', $id)->first();
        
        $data->deleted_at = Carbon::now();
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
