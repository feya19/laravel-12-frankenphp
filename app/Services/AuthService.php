<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Auth\AuthenticationException;

class AuthService
{
    /**
     * Mengautentikasi user dan membuat token.
     *
     * @param string $email
     * @param string $password
     * @return array
     * @throws AuthenticationException
     */
    public function loginUser(string $email, string $password): array
    {
        $user = User::where('email', $email)->first();

        if (! $user || ! Hash::check($password, $user->password)) {
            throw new AuthenticationException('Kredensial tidak valid.');
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'access_token' => $token,
            'token_type'   => 'Bearer',
            'user'         => $user->only(['id', 'name', 'email', 'role']),
        ];
    }
}
