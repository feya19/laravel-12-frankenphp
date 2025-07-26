<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

Route::group(['prefix' => 'v1'],function () {
    Route::post('/token', [AuthController::class, 'token']);
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    })->middleware('auth:sanctum');
});

