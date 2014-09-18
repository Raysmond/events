# Dynamic Events

## Installation

1. `git clone https://github.com/Raysmond/events`

2. Configure MySQL database (config/database.yml)
3. Initialize database

	  ```bash
	  rake db:create
	  rake db:migrate
	  rake db:seed
	  ```

4. Sign in and see how it works
   user a: `a@a.com:111`
   user b: `b@b.com:111`
   user c: `c@c.com:111`
   ```
   rails s
   ```
5. Run tests

	```bash
	bundle exec rspec
	```
