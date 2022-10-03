<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookOutFavorite;
use Validator;
use Illuminate\Support\Facades\DB;

class BookOutFavoriteController extends Controller
{
    public function add(Request $request)
    {
        $request->validate([
            'bookType' => 'required',
            'userID' => 'required',
            'bookID' => 'required',
        ]);

        $data = new BookOutFavorite;
        
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

        $data = BookOutFavorite::where('book_type',$request->bookType)
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
