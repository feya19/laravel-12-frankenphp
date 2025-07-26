<?php

namespace App\Http\Controllers\Api;

use Exception;
use Illuminate\Http\Request;
use App\Services\AuthService;
use Illuminate\Auth\AuthenticationException;

class AuthController extends ApiController
{
    protected AuthService $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    public function token(Request $request)
    {
        try {
            $credentials = $request->validate([
                'email' => 'required|email',
                'password' => 'required',
            ]);

            $result = $this->authService->loginUser(
                $credentials['email'],
                $credentials['password']
            );

            return $this->response($result);
        } catch (AuthenticationException $e) {
            return $this->response($e->getMessage(), 401);
        }
    }
}
