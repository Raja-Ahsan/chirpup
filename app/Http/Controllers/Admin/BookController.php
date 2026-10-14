<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Book;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class BookController extends Controller
{
    public function index(Request $request): View
    {
        $search = trim((string) $request->query('q', ''));

        $books = Book::query()
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('title', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.books.index', [
            'books' => $books,
            'search' => $search,
        ]);
    }

    public function create(): View
    {
        return view('screens.admin.books.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $data = collect($this->validated($request))->except('image')->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request);
        }

        Book::query()->create($data);

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book created successfully.');
    }

    public function edit(Book $book): View
    {
        return view('screens.admin.books.edit', [
            'book' => $book,
        ]);
    }

    public function update(Request $request, Book $book): RedirectResponse
    {
        $data = collect($this->validated($request, $book))->except('image')->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($book->image_url);
            $data['image_url'] = $this->storeImage($request);
        }

        $book->update($data);

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book updated successfully.');
    }

    public function destroy(Book $book): RedirectResponse
    {
        $this->deleteImageFile($book->image_url);
        $book->delete();

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book deleted successfully.');
    }

    private function validated(Request $request, ?Book $book = null): array
    {
        return $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $book ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/books');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('book_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $seedImages = [
            'book1.png',
            'book2.png',
            'book3.png',
        ];

        if (in_array($filename, $seedImages, true)) {
            return;
        }

        $path = public_path('assets/books/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
