<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        channels: __DIR__.'/../routes/channels.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        //
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (ThrottleRequestsException $e, Request $request) {
            if ($request->expectsJson() || $request->ajax()) {
                return response()->json([
                    'message' => $e->getMessage(),
                ], 429);
            } else {
                return response($e->getMessage(), 429);
            }
        });

        $exceptions->render(function (ValidationException $e, Request $request) {
            $validator = $e->validator;
            $errors = $validator->errors();

            if ($request->is('api/*')) {
                $errors = $errors->toArray();
                foreach ($errors as $field => $messages) {
                    $errors[$field] = $messages[0];
                }
            }

            if ($request->expectsJson() || $request->ajax()) {
                return response()->json([
                    'message' => $e->getMessage(),
                    'errors' => $errors
                ], 422);
            }
            return redirect()->back()->withInput()->withErrors($errors);
        });
    })->create();
