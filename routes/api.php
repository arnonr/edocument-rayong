<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\BookInController;
use App\Http\Controllers\BookOutController;
use App\Http\Controllers\BookCodeController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\BookTypeController;
use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\EmailController;
use App\Http\Controllers\BookFavoriteController;
use App\Http\Controllers\BookOutFavoriteController;
use App\Http\Controllers\BookStatusController;
use App\Http\Controllers\BookYearController;
use App\Http\Controllers\SettingController;

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

Route::group(['prefix' => 'auth'], function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);

    Route::group(['middleware' => 'auth:api'], function() {
      Route::get('logout', [AuthController::class, 'logout']);
      Route::get('user', [AuthController::class, 'user']);
    });
});

Route::group(['prefix' => 'bookIn'], function () {
    Route::get('/{id}', [BookInController::class, 'get']);
    Route::get('/', [BookInController::class, 'getAll']);
    Route::get('/getWithYear/{id}', [BookInController::class, 'getWithYear']);
    Route::post('/', [BookInController::class, 'add']);
    Route::put('/', [BookInController::class, 'edit']);
    Route::delete('/{id}', [BookInController::class, 'delete']);
});

Route::group(['prefix' => 'category'], function () {
    Route::get('/', [CategoryController::class, 'getAll']);
    Route::get('/{id}', [CategoryController::class, 'get']);
    Route::post('/', [CategoryController::class, 'add']);
    Route::put('/', [CategoryController::class, 'edit']);
    Route::delete('/{id}', [CategoryController::class, 'delete']);
});

Route::group(['prefix' => 'department'], function () {
    Route::get('/', [DepartmentController::class, 'getAll']);
    Route::get('/{id}', [DepartmentController::class, 'get']);
    Route::post('/', [DepartmentController::class, 'add']);
    Route::put('/', [DepartmentController::class, 'edit']);
    Route::delete('/{id}', [DepartmentController::class, 'delete']);
});

Route::group(['prefix' => 'bookCode'], function () {
    Route::get('/', [BookCodeController::class, 'getActive']);
    Route::get('/old/{id}', [BookCodeController::class, 'getWithYear']);
    Route::put('/', [BookCodeController::class, 'edit']);
});

Route::group(['prefix' => 'user'], function () {
    Route::get('{id}', [UserController::class, 'get']);
    // Route::get('/', [UserController::class, 'getAll']);
    Route::put('/', [UserController::class, 'edit']);
});

Route::group(['prefix' => 'email'], function () {
    Route::get('/person', [EmailController::class, 'getAllPerson']);
    Route::get('/person/{id}', [EmailController::class, 'getPerson']);
    Route::post('/person', [EmailController::class, 'addPerson']);
    Route::put('/person', [EmailController::class, 'editPerson']);
    Route::delete('/person/{id}', [EmailController::class, 'deletePerson']);
    // Group
    Route::get('/group', [EmailController::class, 'getAllGroup']);
    Route::get('/group/{id}', [EmailController::class, 'getGroup']);
    Route::post('/group', [EmailController::class, 'addGroup']);
    Route::put('/group', [EmailController::class, 'editGroup']);
    Route::delete('/group/{id}', [EmailController::class, 'deleteGroup']);
});

Route::group(['prefix' => 'bookFavorite'], function () {
    Route::post('/', [BookFavoriteController::class, 'add']);
    Route::post('/delete', [BookFavoriteController::class, 'delete']);
});

Route::group(['prefix' => 'bookOut'], function () {
    Route::get('/{id}', [BookOutController::class, 'get']);
    Route::get('/', [BookOutController::class, 'getAll']);
    Route::post('/', [BookOutController::class, 'add']);
    Route::put('/', [BookOutController::class, 'edit']);
    Route::delete('/{id}', [BookOutController::class, 'delete']);
    Route::get('/getWithYear/{id}', [BookOutController::class, 'getWithYear']);
    Route::put('/changeStatus', [BookOutController::class, 'changeStatus']);
});

Route::group(['prefix' => 'bookOutFavorite'], function () {
    Route::post('/', [BookOutFavoriteController::class, 'add']);
    Route::post('/delete', [BookOutFavoriteController::class, 'delete']);
});

Route::group(['prefix' => 'bookType'], function () {
    Route::get('/', [BookTypeController::class, 'getAll']);
    Route::get('/{id}', [BookTypeController::class, 'get']);
    Route::post('/', [BookTypeController::class, 'add']);
    Route::put('/', [BookTypeController::class, 'edit']);
    Route::delete('/{id}', [BookTypeController::class, 'delete']);
});

Route::group(['prefix' => 'bookStatus'], function () {
    Route::get('/', [BookStatusController::class, 'getAll']);
    Route::get('/{id}', [BookStatusController::class, 'get']);
    Route::post('/', [BookStatusController::class, 'add']);
    Route::put('/', [BookStatusController::class, 'edit']);
    Route::delete('/{id}', [BookStatusController::class, 'delete']);
});

Route::group(['prefix' => 'bookYear'], function () {
    Route::get('/', [BookYearController::class, 'getAll']);
    Route::get('/{id}', [BookYearController::class, 'get']);
    Route::post('/', [BookYearController::class, 'add']);
    Route::put('/', [BookYearController::class, 'edit']);
    Route::delete('/{id}', [BookYearController::class, 'delete']);
});


Route::group(['prefix' => 'users'], function () {
    Route::get('/', [UserController::class, 'getAll']);
    Route::get('/{id}', [UserController::class, 'get']);
    Route::put('/', [UserController::class, 'edit']);
    Route::delete('/{id}', [UserController::class, 'delete']);
});

Route::group(['prefix' => 'setting'], function () {
    Route::get('/', [SettingController::class, 'get']);
    Route::put('/', [SettingController::class, 'edit']);
});

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

