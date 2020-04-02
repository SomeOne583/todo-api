# Todo-API Heroku

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
  * host: Es para saber a donde hacer las requests en los test

Para crear la base de datos usa:

```
$ rake db:create
$ rake db:migrate
```

# Testing
Los test disponibles son para los request pues los modelos no son accesibles de forma directa

```
$ bundle exec rspec
```

# Servicios
Se debe configurar un servicio para ejecutarse a la media noche cada día (puedes usar la gema whenever y el archivo 'shedule.rb' que ya existe en la carpeta 'config/'), esto para que las tareas que no se terminaron vuelvan a su estado de nuevas.

```
$ bundle exec whenever --update-crontab
```

# Ejecución
```
$ rails s
```

# Formato de request
/login:
```
{
  "user": {
    "email": <EMAIL>,
    "password": <PASSWORD>
  }
}
```

/signup:
```
{
  "user": {
    "email": <EMAIL>,
    "password": <PASSWORD>
  }
```

/webhook:
(Debe incluir el token de usuario en el header 'Authorization')
```
{
  "options": {
    "operation": <OPERATION>,
    *ARGS
  }
}
```
