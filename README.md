# Qualia
Qualia is a light Ruby controller & view framework (MVC) that reproduces some of the core functionality provided by Rails. Qualia also implements a basic Object-relational mapping tool (ORM) mimicking the standard ActiveRecord services using [quale](https://github.com/agarun/quale).

## Demo

1. `bundle install`
2. `cd qualia/sample`
3. `ruby app/sample.rb`


## Usage

### Views & Controllers

Classes that extend Qualia's `ControllerBase` have access to the following methods:

* `render(template)` - Render a specific view
* `render_content(content_data, content_type)` - Detailed render
* `redirect_to(url)`
* `session` - Add key-value pairs to the `session` hash to write data to cookies.
* `flash` - Key-value pairs persist through to the next session
* `flash.now` - Key-value pairs only live for the current session (1 response cycle).
* `protect_from_forgery` - Make use of CSRF protection by adding `protect_from_forgery` to any controller to force Qualia to ensure that form data includes a validated authenticity token.

### ORM

`Qualia::SQLObject` is a lightweight version of ActiveRecord::Base that implements common CRUD methods with little overhead.

Query methods include:

* `::all`
* `::find`
* `::where`
* `::destroy_all`
* `#insert`
* `#update`
* `#destroy`

Associations between objects are class methods. For example:

```rb
class Photo < ApplicationRecord
  belongs_to :album
  has_one_through :author,
                  :album,
                  :user_id
end

class Album < ApplicationRecord
  belongs_to :author, foreign_key: :user_id, class_name: :User
  has_many :photos
end

class User < ApplicationRecord
  has_many :albums
end
```

## Future Plans

- [ ] Implement strong parameters (`require`, `permit`)
- [ ] Enable eager loading / pre-fetching
- [ ] Enable more complex `where` queries
- [ ] Add validators & validations
- [ ] Thor command-line interface
- [ ] RubyGems integration
