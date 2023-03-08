<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mou;
use Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;
const whitelist = ['127.0.0.1', "::1","localhost:8105"];

class MouController extends Controller
{
    protected $uploadUrl = 'http://110.164.166.140/storage/';
    public function getAll(Request $request)
    {
        if(in_array($_SERVER['HTTP_HOST'], whitelist)){
            $this->uploadUrl = 'http://localhost:8105/storage/';
        }

        // User DB
        $items = Mou::select(
                'mou.id as id',
                'mou.name as name',
                'mou.partner as partner',
                DB::raw("(CASE WHEN partner_logo_file = NULL THEN 'http://localhost:8105/storage/mou/logo/scg.png'
                    ELSE CONCAT('".$this->uploadUrl."',partner_logo_file) END) AS partner_logo_file"),
                DB::raw("(CASE WHEN mou_file = NULL THEN NULL
                    ELSE CONCAT('".$this->uploadUrl."',mou_file) END) AS mou_file"),
                DB::raw("(CASE WHEN mou_word_file = NULL THEN NULL
                    ELSE CONCAT('".$this->uploadUrl."',mou_word_file) END) AS mou_word_file"),
                'mou.host_id as host_id',
                'mou.country_code as country_code',
                'mou.start_date as start_date',
                'mou.end_date as end_date',
                DB::raw("(CASE WHEN end_date < NOW() THEN 'inActive'
                    WHEN DATEDIFF(end_date, NOW()) <= 7 THEN 'warning'
                    ELSE 'active'
                END) AS status"),
                'mou.type as type',
                DB::raw("(CASE WHEN mou.type = 1 THEN 'ในประเทศ'
                    ELSE 'ต่างประเทศ'
                END) AS type_name"),
                'mou.address as address',
                'mou.is_publish as is_publish',
                'host.name AS host_name',
                'host.name_en AS host_name_en',
                'country.ct_nameTHA AS country_name',
                'country.ct_nameENG AS country_name_en',
                'mou.partner_contact_name as partner_contact_name',
                'mou.partner_contact_phone as partner_contact_phone',
                'mou.partner_contact_email as partner_contact_email',
                'mou.host_contact_name as host_contact_name',
                'mou.host_contact_phone as host_contact_phone',
                'mou.host_contact_email as host_contact_email',
                'mou.remark as remark',
                // 'mou.deleted_at as deleted_at', 
                // 'mou.created_at as created_at', 
                // 'mou.created_by as created_by', 
                // 'mou.updated_at as updated_at',
                // 'mou.updated_by as updated_by',
                DB::raw("DATEDIFF(end_date, NOW()) AS remain_date"),

            )->join('host','mou.host_id','=','host.id')
            ->join('country','mou.country_code','=','country.ct_code')
            // ->with(['host','country'])
            ->where('mou.deleted_at', null);

        if ($request->id) {
            $items->where('mou.id', $request->id);
        }

        if ($request->name) {
            $items->where('mou.name','LIKE',"%".$request->name."%");
        }

        if ($request->partner) {
            $items->where('mou.partner','LIKE',"%".$request->partner."%");
        }

        if ($request->host_id) {
            $items->where('mou.host_id',$request->host_id);
        }

        if ($request->country_code) {
            $items->where('mou.country_code',$request->country_code);
        }

        if ($request->type) {
            $items->where('mou.type',$request->type);
        }

        if ($request->is_publish != null) {
            $items->where('mou.is_publish', $request->is_publish);
        }

        if ($request->start_date) {
            $startDate = Carbon::createFromFormat('Y-m-d', $request->start_date);
            $items->whereDate('start_date','>=', $startDate);
        }

        if ($request->end_date) {
            $endDate = Carbon::createFromFormat('Y-m-d', $request->end_date);
            $items->whereDate('end_date','<=', $endDate);
        }

        $date7 = Carbon::now()->addDays(7);

        if($request->status != null){
            if($request->status == 'inActive'){
                $items = $items->where('end_date','<', NOW());
            }
            if($request->status == 'warning'){
                $items = $items->where('end_date','<=', $date7)
                ->where('end_date','>=', NOW());
            }
            if($request->status == 'active'){
                $items = $items->where('end_date','>', $date7);
            }
            
        }  

        if ($request->year) {
            $year = $request->year - 543;
            $items->whereYear('start_date','=', $year);
        }

        if($request->orderBy){
            $items = $items->orderBy($request->orderBy, $request->order);
            
        }else{
            $items = $items->orderBy('id', 'desc');
        }

        $count = $items->count();
        $perPage = $request->perPage ? $request->perPage : 10;
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
        $item = Mou::select(
            'mou.id as id',
            'mou.name as name',
            'mou.partner as partner',
            DB::raw("(CASE WHEN partner_logo_file = NULL THEN 'http://localhost:8105/storage/mou/logo/scg.png'
                ELSE CONCAT('".$this->uploadUrl."',partner_logo_file) END) AS partner_logo_file"),
            DB::raw("(CASE WHEN mou_file = NULL THEN NULL
                ELSE CONCAT('".$this->uploadUrl."',mou_file) END) AS mou_file"),
            DB::raw("(CASE WHEN mou_word_file = NULL THEN NULL
                ELSE CONCAT('".$this->uploadUrl."',mou_word_file) END) AS mou_word_file"),
            'mou.host_id as host_id',
            'mou.country_code as country_code',
            'mou.start_date as start_date',
            'mou.end_date as end_date',
            DB::raw("(CASE WHEN end_date < NOW() THEN 'inActive'
                WHEN DATEDIFF(end_date, NOW()) <= 7 THEN 'warning'
                ELSE 'active'
            END) AS status"),
            'mou.type as type',
            DB::raw("(CASE WHEN mou.type = 1 THEN 'ในประเทศ'
                ELSE 'ต่างประเทศ'
            END) AS type_name"),
            'mou.address as address',
            'mou.is_publish as is_publish',
            'host.name AS host_name',
            'host.name_en AS host_name_en',
            'country.ct_nameTHA AS country_name',
            'country.ct_nameENG AS country_name_en',
            'mou.partner_contact_name as partner_contact_name',
            'mou.partner_contact_phone as partner_contact_phone',
            'mou.partner_contact_email as partner_contact_email',
            'mou.host_contact_name as host_contact_name',
            'mou.host_contact_phone as host_contact_phone',
            'mou.host_contact_email as host_contact_email',
            'mou.remark as remark'
        )->join('host','mou.host_id','=','host.id')
        ->join('country','mou.country_code','=','country.ct_code')
        ->where('mou.id', $id)
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
            'partner as required',
            'host_id as required',
            'country_code as required',
            'type as required',
            'is_publish as required',
        ]);
        
        // Save File Success
        $pathPartnerLogo = null;
        if(($request->partner_logo_file != "") && ($request->partner_logo_file != 'null')){
            $fileNamePartnerLogo = 'logo-'.rand(10,100).'-'.$request->partner_logo_file->getClientOriginalName();
            $pathPartnerLogo = '/mou/logo/'.$fileNamePartnerLogo;
            Storage::disk('public')->put($pathPartnerLogo, file_get_contents($request->partner_logo_file));
        }else{
            return response()->json([
                'message' => 'error Not File Upload'
            ], 200);
        }

        $pathMou = null;
        if(($request->mou_file != "") && ($request->mou_file != 'null')){
            $fileNameMou = 'document-'.rand(10,100).'-'.$request->mou_file->getClientOriginalName();
            $pathMou = '/mou/document/'.$fileNameMou;
            Storage::disk('public')->put($pathMou, file_get_contents($request->mou_file));
        }

        $pathMouWord = null;
        if(($request->mou_word_file != "") && ($request->mou_word_file != 'null')){
            $fileNameMouWord = 'document-'.rand(10,100).'-'.$request->mou_word_file->getClientOriginalName();
            $pathMouWord = '/mou/document/'.$fileNameMouWord;
            Storage::disk('public')->put($pathMouWord, file_get_contents($request->mou_word_file));
        }

        $data = new Mou;
        $data->name = $request->name;
        $data->partner = $request->partner;
        $data->partner_logo_file = $pathPartnerLogo;
        $data->mou_file = $pathMou;
        $data->mou_word_file = $pathMouWord;
        $data->host_id = $request->host_id;
        $data->country_code = $request->country_code;
        $data->start_date = $request->start_date;
        $data->end_date = $request->end_date;
        $data->address = $request->address;
        $data->type = $request->type;
        $data->is_publish = $request->is_publish;
        $data->partner_contact_name = $request->partner_contact_name;
        $data->partner_contact_phone = $request->partner_contact_phone;
        $data->partner_contact_email = $request->partner_contact_email;
        $data->host_contact_name = $request->host_contact_name;
        $data->host_contact_phone = $request->host_contact_phone;
        $data->host_contact_email = $request->host_contact_email;
        $data->remark = $request->remark;
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
            'partner as required',
            'host_id as required',
            'country_code as required',
            'type as required',
            'is_publish as required',
        ]);
        
        $data = Mou::where('id',$id)->first();

        // Save File Success
        $pathPartnerLogo = null;
        if(($request->partner_logo_file != "") && ($request->partner_logo_file != 'null')){
            $fileNamePartnerLogo = 'logo-'.rand(10,100).'-'.$request->partner_logo_file->getClientOriginalName();
            $pathPartnerLogo = '/mou/logo/'.$fileNamePartnerLogo;
            Storage::disk('public')->put($pathPartnerLogo, file_get_contents($request->partner_logo_file));
        }else{
            $pathPartnerLogo = $data->partner_logo_file;
        }

        $pathMou = null;
        if(($request->mou_file != "") && ($request->mou_file != 'null')){
            $fileNameMou = 'document-'.rand(10,100).'-'.$request->mou_file->getClientOriginalName();
            $pathMou = '/mou/document/'.$fileNameMou;
            Storage::disk('public')->put($pathMou, file_get_contents($request->mou_file));
        }else{
            $pathMou = $data->mou_file;
        }

        $pathMouWord = null;
        if(($request->mou_word_file != "") && ($request->mou_word_file != 'null')){
            $fileNameMouWord = 'document-'.rand(10,100).'-'.$request->mou_word_file->getClientOriginalName();
            $pathMouWord = '/mou/document/'.$fileNameMouWord;
            Storage::disk('public')->put($pathMouWord, file_get_contents($request->mou_word_file));
        }else{
            $pathMouWord = $data->mou_word_file;
        }

        $data->name = $request->name;
        $data->partner = $request->partner;
        $data->partner_logo_file = $pathPartnerLogo;
        $data->mou_file = $pathMou;
        $data->mou_word_file = $pathMouWord;
        $data->host_id = $request->host_id;
        $data->country_code = $request->country_code;
        $data->start_date = $request->start_date;
        $data->end_date = $request->end_date;
        $data->address = $request->address;
        $data->type = $request->type;
        $data->is_publish = $request->is_publish;
        $data->partner_contact_name = $request->partner_contact_name;
        $data->partner_contact_phone = $request->partner_contact_phone;
        $data->partner_contact_email = $request->partner_contact_email;
        $data->host_contact_name = $request->host_contact_name;
        $data->host_contact_phone = $request->host_contact_phone;
        $data->host_contact_email = $request->host_contact_email;
        $data->remark = $request->remark;
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
        $data = Mou::where('id', $id)->first();
        
        $data->deleted_at = Carbon::now();
        $data->save();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
