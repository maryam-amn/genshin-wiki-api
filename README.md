### Description of the project 

This project is a web app around the game "Genshin impact". Each user can view a character, 
add them to their collection, add a comment or rate them.  


## Requirement
- PostreSQL (psql) for database management
- Node
- Ruby
- Create `.env` file and copie the content of [env.template](.env.template)

### Initial set up
- Run the command below
```bash
rails db:prepare db:create db:migrate db:fixtures:load
```
- it will
  - prepare and create the database
  - do all migration
  - Load fixtures
  
### Launch server
- Run the command below
```bash
rails server 
```

Open your browser and go to <http://127.0.0.1:3000/>

### Connect to a the admin user
- run db::seed 
- Connect to this user with 
  - email : admin@example.com
  - password : password

=> if you want to change it, you can change in [db/seeds.rb](db/seeds.rb)