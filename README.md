# Todo-API

Es una API para manejar una página de tareas, la página esta alojada en: 

# Datos técnicos

Versión de Ruby: 2.7

Versión de Rails: 6.0.2.2

Metodos válidos: [get, post, delete]

Base de datos: PostgreSQL

Variables definidas en rails credentials:
  * pg_user: Usuario de postgresql
  * pg_password: Contraseña de postgresql
  * jwt_secret: Clave para que devise-jwt encripte las contraseñas
  * frontend: URL del frontend que lo administrara

Para crear la base de datos usa:

```
$ rake db:create
$ rake db:migrate
```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

No olvides que tienes un crontab que iniciar con whenever