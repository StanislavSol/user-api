<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email|unique:users',
            'password' => ['required', Password::min(6)],
            'gender' => 'nullable|in:male,female,other',
        ]);

        $user = User::create([
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'gender' => $validated['gender'] ?? null,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

         return response()->json([
             'message' => 'User registered successfully',
             'user' => $user,
             'access_token' => $token,
             'token_type' => 'Bearer',
         ], 201);

    }

    public function profile(Request $request)
    {
        return response()->json([
            'user' => $request->user(),
        ]);
    }
}
