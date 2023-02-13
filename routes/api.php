<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\CountryController;
use App\Http\Controllers\MouController;
use App\Http\Controllers\HostController;
use App\Http\Controllers\ActivityController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::group(['prefix' => 'auth'], function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);

    Route::group(['middleware' => 'auth:api'], function() {
      Route::get('logout', [AuthController::class, 'logout']);
      Route::get('user', [AuthController::class, 'user']);
    });
});


Route::group(['prefix' => 'user'], function () {
    Route::get('/{id}', [UserController::class, 'get']);
    Route::get('/', [UserController::class, 'getAll']);
    Route::post('/', [UserController::class, 'add']);
    Route::put('/{id}', [UserController::class, 'edit']);
    Route::delete('/{id}', [UserController::class, 'delete']);
});

Route::group(['prefix' => 'activity'], function () {
    Route::get('/{id}', [ActivityController::class, 'get']);
    Route::get('/', [ActivityController::class, 'getAll']);
    Route::post('/', [ActivityController::class, 'add']);
    Route::put('/{id}', [ActivityController::class, 'edit']);
    Route::delete('/{id}', [ActivityController::class, 'delete']);
});

Route::group(['prefix' => 'mou'], function () {
    Route::get('/{id}', [MouController::class, 'get']);
    Route::get('/', [MouController::class, 'getAll']);
    Route::post('/', [MouController::class, 'add']);
    Route::put('/{id}', [MouController::class, 'edit']);
    Route::delete('/{id}', [MouController::class, 'delete']);
});

Route::group(['prefix' => 'country'], function () {
    Route::get('/{id}', [CountryController::class, 'get']);
    Route::get('/', [CountryController::class, 'getAll']);
    Route::post('/', [CountryController::class, 'add']);
    Route::put('/{id}', [CountryController::class, 'edit']);
    Route::delete('/{id}', [CountryController::class, 'delete']);
});

Route::group(['prefix' => 'host'], function () {
    Route::get('/{id}', [HostController::class, 'get']);
    Route::get('/', [HostController::class, 'getAll']);
    Route::post('/', [HostController::class, 'add']);
    Route::put('/{id}', [HostController::class, 'edit']);
    Route::delete('/{id}', [HostController::class, 'delete']);
});

// Route::middleware('auth:api')->get('/user', function (Request $request) {
//     return $request->user();
// });