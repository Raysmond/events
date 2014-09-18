# Dynamic Events

## Installation

1. `git clone https://github.com/Raysmond/events`

2. Configure MySQL database (config/database.yml)
3. Initialize database

	  ```bash
	  bundle
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
	Try the following actions:
	- Create some todos
	- Complete a todo item
	- Delete a todo item
	- Assign a user to a todo item
	- Reassign a user to a todo item
	- Update todo deadline
	- Add some comments to a todo item
	- Go to the `/events` page and see the events stream
   
5. Run tests

	```bash
	rspec
	```
