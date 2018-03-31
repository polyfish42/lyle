# Lyle

_"Do not underestimate objects!" - Lyle, Inifinite Jest_

Lyle is an MVC framework for building web applications. Some features include:

* SQLite3 ORM with associations and search
* Controllers with Session and Flash Management
* CSRF Protetion
* Static Asset Rendering
* Exception and Error Handling
* Regex Routing
* Server

For an example, visit: [https://github.com/polyfish42/cat-crud](https://github.com/polyfish42/cat-crud)

# Basic Usage

## Set Up

### Database

Lyle's ORM works with SQLite3, so you'll need to first write a .sql file to seed your database. Once done, put that file in your root directory and put it's filename in `lib/model_base/db_connection.rb`. Include your desired db name as well.

```
SQL_FILE = File.join(ROOT_FOLDER, 'PUT_YOUR_SQL_FILE_NAME_HERE')
DB_FILE = File.join(ROOT_FOLDER, 'PUT_YOUR_DB_FILE_NAME_HERE')
```

Your database will automatically be created when you run the server.

### Routes

Routes go in the `config/application.rb` file. Their format is http-method -> regex of the url path to match -> controller to route to -> action to invoke.

```
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  post Regexp.new("^/cats$"), CatsController, :create
```
### Views
Views are placed in `app/views`. You can render them directly, or Lyle will look for a view that matches the controller and action invoked by default.

### Controllers

Controllers are placed in the `app/controllers` folder. Require the **AppController** file (in the same directory) and make sure your controller inherits from AppController.

### Models
Place model classes in `app/models`, require **AppModel**, and make sure all models inherit from AppModel.

### Run the server
In terminal, run:
```
ruby config/application.rb
```

#API

**::protect_from_forgery** Run this method inside any controller you want CSRF protection in.
```
class CatsController < ControllerBase
protect_from_forgery
```

**#form_authentication_token** Place this as a hidden input in any of your forms when `protect_from_forgery` is enabled.

**#belongs_to, #has_many, #has_one_through** Invoke these callbacks in your models to associate different tables in your database. Provide the primary key, foreign key, and class name of associations or leave them out if your foreign key and class name are the same.

**#session** Access the session cookies for basic auth in your controllers.

**#flash** Used when you want information to be available in the cookies for one request/response cycle (like when displaying errors). Use `flash.now` when you want the cookie to last the rest of a single response.

**#where** search the databse with SQL where queries.
```
Cat.where(name: 'Kevin', owner: 'Oscar')
```
