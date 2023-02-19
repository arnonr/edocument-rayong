<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\CountryController;
use App\Http\Controllers\MouController;
use App\Http\Controllers\HostController;
use App\Http\Controllers\ActivityController;
// 
use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\BookStatusController;
use App\Http\Controllers\EmailPersonController;
use App\Http\Controllers\EmailGroupController;

use App\Http\Controllers\BookInCategoryController;
use App\Http\Controllers\BookInTypeController;
use App\Http\Controllers\BookInController;
use App\Http\Controllers\BookYearController;
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

Route::group(['prefix' => 'department'], function () {
    Route::get('/', [DepartmentController::class, 'getAll']);
    Route::get('/{id}', [DepartmentController::class, 'get']);
    Route::post('/', [DepartmentController::class, 'add']);
    Route::put('/', [DepartmentController::class, 'edit']);
    Route::delete('/{id}', [DepartmentController::class, 'delete']);
});


Route::group(['prefix' => 'book-in-category'], function () {
    Route::get('/', [BookInCategoryController::class, 'getAll']);
    Route::get('/{id}', [BookInCategoryController::class, 'get']);
    Route::post('/', [BookInCategoryController::class, 'add']);
    Route::put('/', [BookInCategoryController::class, 'edit']);
    Route::delete('/{id}', [BookInCategoryController::class, 'delete']);
});

Route::group(['prefix' => 'book-in-type'], function () {
    Route::get('/', [BookInTypeController::class, 'getAll']);
    Route::get('/{id}', [BookInTypeController::class, 'get']);
    Route::post('/', [BookInTypeController::class, 'add']);
    Route::put('/', [BookInTypeController::class, 'edit']);
    Route::delete('/{id}', [BookInTypeController::class, 'delete']);
});

Route::group(['prefix' => 'book-in'], function () {
    Route::get('/generate-code', [BookInController::class, 'generateCode']);
    Route::get('/{id}', [BookInController::class, 'get']);
    Route::get('/', [BookInController::class, 'getAll']);
    Route::post('/', [BookInController::class, 'add']);
    Route::put('/{id}', [BookInController::class, 'edit']);
    Route::delete('/{id}', [BookInController::class, 'delete']);
});

Route::group(['prefix' => 'book-status'], function () {
    Route::get('/{id}', [BookStatusController::class, 'get']);
    Route::get('/', [BookStatusController::class, 'getAll']);
    Route::post('/', [BookStatusController::class, 'add']);
    Route::put('/', [BookStatusController::class, 'edit']);
    Route::delete('/{id}', [BookStatusController::class, 'delete']);
});

Route::group(['prefix' => 'email'], function () {
    Route::get('/person/{id}', [EmailPersonController::class, 'get']);
    Route::get('/person', [EmailPersonController::class, 'getAll']);
    Route::post('/person', [EmailPersonController::class, 'add']);
    Route::put('/person', [EmailPersonController::class, 'edit']);
    Route::delete('/person/{id}', [EmailPersonController::class, 'delete']);

    Route::get('/group/{id}', [EmailGroupController::class, 'get']);
    Route::get('/group', [EmailGroupController::class, 'getAll']);
    Route::post('/group', [EmailGroupController::class, 'add']);
    Route::put('/group', [EmailGroupController::class, 'edit']);
    Route::delete('/group/{id}', [EmailPersonController::class, 'delete']);
});

Route::group(['prefix' => 'book-year'], function () {
    Route::get('/{id}', [BookYearController::class, 'get']);
    Route::get('/', [BookYearController::class, 'getAll']);
    Route::post('/', [BookYearController::class, 'add']);
    Route::put('/', [BookYearController::class, 'edit']);
    Route::delete('/{id}', [BookYearController::class, 'delete']);
});

// Route::middleware('auth:api')->get('/user', function (Request $request) {
//     return $request->user();
// });