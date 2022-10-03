<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookFavorite;
use Validator;
use Illuminate\Support\Facades\DB;

class BookFavoriteController extends Controller
{
    // public function getAll($id)
    // {
    //     // User DB
    //     $data = BookFavorite::select(
    //             'id as id',
    //             'user_id as userID',
    //             'book_id as bookID',
    //             'book_type as bookType',
    //             'created_at as createdAt',
    //             'updated_at as updatedAt',
    //         )
    //         ->where('user_id',$id)
    //         ->where('active', 1)
    //         ->get();
        
    //     return response()->json([
    //         'message' => 'success',
    //         'favorite' => $data,
    //     ], 200);
    // }
    
    public function add(Request $request)
    {
        $request->validate([
            'bookType' => 'required',
            'userID' => 'required',
            'bookID' => 'required',
        ]);

        $data = new BookFavorite;
        
        $data->book_type = $request->bookType;
        $data->user_id = $request->userID;
        $data->book_id = $request->bookID;
        $data->save();
        
        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }

    public function delete(Request $request)
    {
        $request->validate([
            'bookType' => 'required',
            'userID' => 'required',
            'bookID' => 'required',
        ]);

        $data = BookFavorite::where('book_type',$request->bookType)
            ->where('user_id',$request->userID)
            ->where('book_id',$request->bookID)
            ->first();

        $data->delete();

        $responseData = [
            'message' => 'success'
        ];

        return response()->json($responseData, 200);
    }
}
