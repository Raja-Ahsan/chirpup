@extends('layouts.admin.app')

@section('title', 'Dashboard')
@section('page_title', 'Dashboard')
@section('page_subtitle', 'Overview of your ChirpUp admin workspace')

@section('content')
    <div class="cu-grid cu-grid--stats">
        @foreach ($stats as $stat)
            @if (! empty($stat['route']))
                <a href="{{ route($stat['route']) }}" class="cu-card cu-stat-card">
                    <div class="cu-stat-card__head">
                        <p class="cu-stat__label">{{ $stat['label'] }}</p>
                        <i class="{{ $stat['icon'] }}" aria-hidden="true"></i>
                    </div>
                    <p class="cu-stat__value">{{ number_format($stat['value']) }}</p>
                    <p class="cu-stat__trend is-up">{{ $stat['meta'] }}</p>
                </a>
            @else
                <section class="cu-card cu-stat-card">
                    <div class="cu-stat-card__head">
                        <p class="cu-stat__label">{{ $stat['label'] }}</p>
                        <i class="{{ $stat['icon'] }}" aria-hidden="true"></i>
                    </div>
                    <p class="cu-stat__value">{{ number_format($stat['value']) }}</p>
                    <p class="cu-stat__trend is-up">{{ $stat['meta'] }}</p>
                </section>
            @endif
        @endforeach
    </div>

    <div class="cu-grid cu-grid--secondary">
        <section class="cu-card cu-panel-card">
            <div class="cu-panel-card__head">
                <h3>Recent users</h3>
            </div>
            <div class="cu-table-wrap">
                <table class="cu-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Joined</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($recentUsers as $user)
                            <tr>
                                <td>{{ $user->name }}</td>
                                <td>{{ $user->email }}</td>
                                <td>{{ $user->created_at?->format('M j, Y') }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="3" class="cu-empty">No users yet.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </section>

        <section class="cu-card cu-panel-card">
            <div class="cu-panel-card__head">
                <h3>Games by year</h3>
            </div>
            <div class="cu-table-wrap">
                <table class="cu-table">
                    <thead>
                        <tr>
                            <th>Year</th>
                            <th>Active games</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($gamesByYear as $year)
                            <tr>
                                <td>{{ $year->title }}</td>
                                <td>{{ $year->games_count }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="2" class="cu-empty">No years found.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            <p class="cu-note">
                {{ number_format($activeGameTypes) }} active game types · {{ number_format($sketchCount) }} sketches
            </p>
        </section>

        <section class="cu-card cu-panel-card">
            <div class="cu-panel-card__head">
                <h3>Recent game types</h3>
                <a href="{{ route('admin.game-types.index') }}" class="cu-btn cu-btn--ghost" style="padding:0.35rem 0.7rem;font-size:0.8rem;">View all</a>
            </div>
            <div class="cu-table-wrap">
                <table class="cu-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Year</th>
                            <th>Sketches</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($recentGameTypes as $gameType)
                            <tr>
                                <td>{{ $gameType->name }}</td>
                                <td>{{ $gameType->year?->title ?? '—' }}</td>
                                <td>{{ $gameType->sketches_count }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="3" class="cu-empty">No game types yet.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </section>
    </div>
@endsection
