# Laravel Crud Admin Helper

This is a simple bash script to help developers whip up templates for repetitive crud operations using  shell prompt.

## What is does

1.  Creates the model class
2.  Creates migration for model
3.  Creates controller with pre-populated methods to handle crud operations
4. Creates Views for crud operations from a pre-populated template

## Installation

Clone the repository to your device

## Usage

With your terminal execute the script by running.
```bash
   ./index.sh
```
This will bring up a prompt to find your laravel root directory. Add the appropriate path to your laravel application and follow the prompt all the way to the end.

---

You can modify the template views for each operation (create, index, show, edit) to suit your design by editing the file in **~/templates/layout/\*.php**

---

You can also modify the controller template to suit your coding style by editing the files in **~/templates/controller/controllerTemplate.php**

KEY:
-  _CONTROLLER : The name of the controller will be inserted here
-  _MODEL: The name of the model will be inserted here
-  _STORE_REQUEST: The store request validation via dependency injection
-  _EDIT_REQUEST: The update request validation via dependency injection

## NOTE
You need to add the route as so to your web.php
```php 
Route::resource('<modelName>', <ModelName>Controller::class);

Route::resource('photo', PhotoController::class);

```
This file generator was built with laravel 8 in mind but it can easily be modified to work with any laravel versions

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
Free