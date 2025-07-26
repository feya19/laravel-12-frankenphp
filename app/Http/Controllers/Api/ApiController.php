<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\File;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ApiController extends Controller {

    public function response($message, $data = null, ?int $code = null): JsonResponse
    {
        $code = $code ?? Response::HTTP_OK;
        $response = $this->buildResponse($message, $data);
        return response()->json($response, $code);
    }

    protected function buildResponse($message, $data = null): array
    {
        $response = [];
        if (is_array($message) || is_object($message)) {
            $response['data'] = $message;
        } else {
            $response['message'] = $message;
        }
        if ($data !== null) {
            $response['data'] = $data;
        } elseif (is_array($message)) {
            $response['data'] = $message;
        }
        return $response;
    }

    public function file(string $path, ?string $fileName = null): StreamedResponse
    {
        if (!file_exists($path) || !is_readable($path)) {
            throw new HttpResponseException(response()->json([
                'message' => 'File not found or not readable.'
            ], Response::HTTP_NOT_FOUND));
        }
        $fileName = $fileName ?? basename($path);
        $contentType = File::type($path);
        if ($contentType == 'pdf') {
            $this->stream($path, $fileName);
        }
        return $this->download($path, $fileName, $contentType);
    }

    protected function download(string $path, string $fileName, string $contentType): StreamedResponse
    {
        return response()->streamDownload(function() use ($path) {
            readfile($path);
        }, $fileName, [
            'Content-Type' => $contentType,
            'Content-Length' => filesize($path)
        ]);
    }

    protected function stream($path, $filename): StreamedResponse
    {
        return response()->stream(function () use ($path) {
            $stream = fopen($path, 'rb');
            fpassthru($stream);
            fclose($stream);
        }, 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => 'inline; filename="' . $filename . '"'
        ]);
    }
}
