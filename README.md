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

### Preview email 
we have two way to previews/view the emails send to a user :

Rails : 
-  To have the preview of all emails, Launch the server, and go to :
    - http://localhost:3000/rails/mailers/devise_mailer

Docker :
- Run the command below 
    - it will catch the email received by the user with `mailctacher`, and we can view it at http://localhost:1080/

```bash
docker run -it -p 1080:1080 -p 1025:1025 --name mailcatcher stpaquet/alpinemailcatcher
 ```