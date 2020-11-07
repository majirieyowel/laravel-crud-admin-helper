<?php

namespace App\Http\Controllers\Admin;

/**
 * Template generated from bash script
 * Author: Majiri Eyowel
 * Email: majirieyowel@gmail.com
 * Date : _DATE
 */

use App\Models\_MODEL;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Requests\_STORE_REQUEST;
use App\Http\Requests\_EDIT_REQUEST;

use App\Http\Controllers\Controller;

class _CONTROLLER extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $data['title'] = ucfirst('_MODEL');

        $data['active'] = (object) [
            'link' => strtolower('_MODEL'),
            'parent' => strtolower('_MODEL')
        ];

        $data['breadcrumb'] = [
            [
                'page' => ucfirst('_MODEL'),
                'url' => '',
                'active' => true
            ]
        ];

        if ($query = request()->query('q')) {

            // TODO: UNCOMMENT AND FIX WHERE CLAUSE
            // $items = _MODEL::where('', 'like', '%' . $query . '%')
            //     ->orWhere('', 'like', '%' . $query . '%')
            //     ->distinct()
            //     ->orderBy('id', 'desc');

        } else {

            $items = _MODEL::orderBy('id', 'desc');
        }

        $paginated = $items->paginate(15);

        $data['items'] = $paginated;

        return view('admin.' . strtolower('_MODEL') . '.index', $data);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $data['title'] = 'Add _MODEL';

        $data['active'] = (object) [
            'link' => strtolower('_MODEL'),
            'parent' => strtolower('_MODEL')
        ];

        $data['breadcrumb'] = [
            [
                'page' => 'All ' . ucfirst('_MODEL'),
                'url' => '/admin/_RMODEL',
                'active' => false
            ],
            [
                'page' => 'New _MODEL',
                'url' => '',
                'active' => true
            ]
        ];

        return view('admin.' . strtolower('_MODEL') . '.create', $data);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\_STORE_REQUEST  $request
     * @return \Illuminate\Http\Response
     */
    public function store(_STORE_REQUEST $request)
    {

        $model = new _MODEL;
        // $model-> = $request
        $model->save();

        return redirect("/admin/_RMODEL/$model->id")->with('success', 'Created Successfully!');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\_MODEL  $_RMODEL
     * @return \Illuminate\Http\Response
     */
    public function show(_MODEL $_RMODEL)
    {
        $data['title'] = 'Display _MODEL';

        $data['active'] = (object) [
            'link' => strtolower('_MODEL'),
            'parent' => strtolower('_MODEL')
        ];

        $data['breadcrumb'] = [
            [
                'page' => 'All ' . ucfirst('_MODEL'),
                'url' => '/admin/_RMODEL',
                'active' => false
            ],
            [
                'page' => ucfirst('_MODEL'),
                'url' => '',
                'active' => true
            ]
        ];

        $data['item'] = $_RMODEL;

        return view('admin.' . strtolower('_MODEL') . '.show', $data);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\_MODEL  $_RMODEL
     * @return \Illuminate\Http\Response
     */
    public function edit(_EDIT_REQUEST $_RMODEL)
    {
        $data['title'] = 'Update _MODEL';

        $data['active'] = (object) [
            'link' => strtolower('_MODEL'),
            'parent' => strtolower('_MODEL')
        ];

        $data['breadcrumb'] = [
            [
                'page' => 'All ' . ucfirst('_MODEL'),
                'url' => '/admin/_RMODEL',
                'active' => false
            ],
            [
                'page' => 'Update ' . ucfirst('_MODEL'),
                'url' => '',
                'active' => true
            ]
        ];

        $data['item'] = $_RMODEL;

        return view('admin.' . strtolower('_MODEL') . '.edit', $data);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\_MODEL  $_RMODEL
     * @return \Illuminate\Http\Response
     */
    public function update(_EDIT_REQUEST $request, _MODEL $_RMODEL)
    {

        // $_RMODEL-> = 
        // $_RMODEL->save();

        return back()->with('success', 'Updated Successfully!');;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\_MODEL  $_RMODEL
     * @return \Illuminate\Http\Response
     */
    public function destroy(_MODEL $_RMODEL)
    {
        $_RMODEL->delete();

        return back()->with('success', 'Deleted Successfully!');;
    }
    /**
     * Working with images help
     */

    // $filename = 'image';
    // $filepath = 'public/images/';

    // if ($request->$filename) {

    //     $title = \shorten_text(request()->title, 50, '');

    //     $title = $title ?? Str::random(10);

    //     $slugify_name = slug($title) . '-' . Str::random(5) . '.' . $request->$filename->getClientOriginalExtension();;

    //     $request->$filename->storeAs($filepath, $slugify_name);
    // }

}
