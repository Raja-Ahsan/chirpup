<?php

use App\Http\Middleware\AddApiStatusCode;
use App\Http\Middleware\EnsureUserIsAdmin;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'admin' => EnsureUserIsAdmin::class,
        ]);

        $middleware->api(append: [
            AddApiStatusCode::class,
        ]);

        $middleware->redirectGuestsTo(function (Request $request) {
            return $request->is('admin') || $request->is('admin/*')
                ? route('admin.login')
                : route('login');
        });

        $middleware->redirectUsersTo(function (Request $request) {
            $user = $request->user();

            if ($user && $user->hasRole(config('roles.admin'))) {
                return route('admin.dashboard');
            }

            return route('dashboard');
        });
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(function (Request $request, \Throwable $e) {
            return $request->is('api/*') || $request->expectsJson();
        });

        $exceptions->respond(function ($response, \Throwable $e, Request $request) {
            if (
                ($request->is('api/*') || $request->expectsJson())
                && $response instanceof JsonResponse
            ) {
                $payload = $response->getData(true);

                if (is_array($payload)) {
                    $payload['code'] = $response->getStatusCode();
                    $response->setData($payload);
                }
            }

            return $response;
        });
    })->create();
