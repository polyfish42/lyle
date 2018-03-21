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

### Controllers

Controllers are placed in the 
