@extends('layouts.admin.app')

@section('title', 'Dashboard')
@section('page_title', 'Dashboard')
@section('page_subtitle', 'Overview of your ChirpUp admin workspace')

@section('content')
    <div class="cu-grid cu-grid--stats">
        <section class="cu-card">
            <p class="cu-stat__label">Revenue</p>
            <p class="cu-stat__value">$45,195</p>
            <p class="cu-stat__trend is-up">+12.4% this month</p>
        </section>

        <section class="cu-card">
            <p class="cu-stat__label">Customers</p>
            <p class="cu-stat__value">845</p>
            <p class="cu-stat__trend is-up">+38 new</p>
        </section>

        <section class="cu-card">
            <p class="cu-stat__label">Orders</p>
            <p class="cu-stat__value">1,284</p>
            <p class="cu-stat__trend is-down">-4.1% today</p>
        </section>

        <section class="cu-card">
            <p class="cu-stat__label">Invoices</p>
            <p class="cu-stat__value">10,905</p>
            <p class="cu-stat__trend is-up">+2.8% this week</p>
        </section>
    </div>

    <div class="cu-grid cu-grid--secondary">
        <section class="cu-card">
            <h3>Top customers</h3>
            <table class="cu-table">
                <thead>
                    <tr>
                        <th>Customer</th>
                        <th>Purchases</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Jane Cooper</td>
                        <td>65</td>
                        <td>$970</td>
                    </tr>
                    <tr>
                        <td>Wade Warren</td>
                        <td>42</td>
                        <td>$300</td>
                    </tr>
                    <tr>
                        <td>Guy Hawkins</td>
                        <td>38</td>
                        <td>$900</td>
                    </tr>
                    <tr>
                        <td>Devin Jake</td>
                        <td>12</td>
                        <td>$500</td>
                    </tr>
                </tbody>
            </table>
        </section>

        <section class="cu-card">
            <h3>Monthly target</h3>
            <p class="cu-stat__value">89%</p>
            <div class="cu-progress" aria-hidden="true">
                <span style="width: 89%"></span>
            </div>
            <p class="cu-note">Revenue is trending well. Today's earnings are up to $3,653.</p>
        </section>

        <section class="cu-card">
            <h3>Activity</h3>
            <table class="cu-table">
                <tbody>
                    <tr>
                        <td>New customer signup</td>
                        <td>7:00 AM</td>
                    </tr>
                    <tr>
                        <td>Invoice #589356 paid</td>
                        <td>5:12 AM</td>
                    </tr>
                    <tr>
                        <td>Product stock updated</td>
                        <td>Yesterday</td>
                    </tr>
                    <tr>
                        <td>Blog draft published</td>
                        <td>Yesterday</td>
                    </tr>
                </tbody>
            </table>
        </section>
    </div>
@endsection
