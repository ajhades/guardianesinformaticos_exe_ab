
# Guardianes Informáticos

API para gestionar turnos de usuarios segun tarea y disponibilidad

Ejericicio realizado para una prueba tecnica de Recorrido.cl

## Descripcion de la prueba 
La empresa GuardianesInformáticos SpA tiene un negocio que ellos llaman MaaS
(Monitoring as a Service). Su personal son expertos ingenieros devops y programadores, y
su tarea es monitorear servicios de otras empresas e incluso desplegar hotfixes si es
necesario. Por problemas de tiempo no han podido desarrollar un sistema que permita
coordinar los turnos de guardia para cada servicio monitoreado, actualmente usan un excel.
para cada servicio que monitorean.

Se le encarga desarrollar un pequeño sistema (MVP) que permita a la empresa replicar lo
que tienen en excel y agregar algunas funcionalidades que en el excel hoy en día hacen de
forma manual






## API Reference

#### Autenticación
A continuación se listan las rutas para el inicio y cierre de session. 
*El token de autorización es necesario para la mayoria de rutas del API*
#### Iniciar sesión

```http
  POST /users/sign_in
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `user.email` | `string` | **Required**. El correo electrónico del usuario |
| `user.password` | `string` | 	**Required**. La contraseña del usuario |

_RESPONSE: success_
```
{
    "code": 200,
    "message": "Logged in successfully.",
    "token": "${token}"
}
```

#### Cerrar sesión

```http
  DELETE /users/sign_out
```
| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

RESPONSE: success

```
{
    "status": 200,
    "message": "Logged out successfully."
}
```
## Servicios
Los servicios dentro del aplicativo son las tareas que se asignan a cada usuario. Estas se programan semanalmente.

### Metodos para la funcionalidad de agendar

Los metodos a continuación perrmiten implementar la funcionalidad de:
- agendar tareas a los usuarios
- listar semanas disponibles por tarea 
- obtener día de inicio y fin de la semana seleccionada
- listar las horas disponibles para cada usuario, por tarea y semanas
- listar las horas implementadas para cada usuario, por tarea y semanas
- listar el total de horas implementadas por cada usuario semanalmente
- listar las días y horas disponibles para cada tarea

#### Agendar semana

```http
  GET /services/schedule_week/${id}?week=${week}&date=${date}
```

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |
| `week`      | `integer` | **Required**. Número de la semana |
| `date`      | `string` | **Required**. Fecha en formato `'%Y-%m-%d'` |

RESPONSE: success

```
{
    "data": [
        {
            "id": 1,
            "week": "27",
            "date": "2024-07-05T00:00:00.000Z",
            "start_time": "14:00",
            "end_time": "16:00",
            "created_at": "2024-07-10T16:36:45.630Z",
            "updated_at": "2024-07-10T16:36:45.630Z",
            "user_id": 2,
            "schedule_id": 2
        },
        ...
    ],
    "message": "Scheduled",
    "total": 5
]
```

#### Listar días de la semanas disponibles por tarea

```http
  GET /services/available_weeks/${id}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |

RESPONSE: success

```
{
    {
        "date": "2024-07-01",
        "week": 27,
        "label": "Semana 27 del 2024"
    },
    ...
]
```

#### Obtener día de inicio y fin de la semana seleccionada

```http
  GET /services/week_selected/?date=${date}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `date`      | `string` | **Required**. Fecha en formato `'%Y-%m-%d'` |

RESPONSE: success

```
{
    "week": "Semana 27 del 2024",
    "date": {
        "start_date": "01/07/2024",
        "end_date": "07/07/2024"
    }
}
```

#### Listar las horas disponibles para cada usuario

```http
  GET /services/available_hours_per_user/${id}?week=${week}&date=${date}
```

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |
| `week`      | `integer` | **Required**. Número de la semana |
| `date`      | `string` | **Required**. Fecha en formato `'%Y-%m-%d'` |

RESPONSE: success

```
[
    {
        "day": 2,
        "date": " 2 de Julio de 2024",
        "available_hours": [
            "03:00",
            "04:00",
            "05:00",
            ...
        ],
        "users": [
            {
                "id": 1,
                "name": "Carmen Garibay",
                "hours": [
                    "03:00",
                    "04:00",
                    "05:00",
                    ...
                ],
                "total": 0
            },
            ...
        ]
    },
    ...
]
```

#### Listar las horas implementadas para cada usuario

```http
  GET /services/used_hours_per_user/${id}?week=${week}&date=${date}
```

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |
| `week`      | `integer` | **Required**. Número de la semana |
| `date`      | `string` | **Required**. Fecha en formato `'%Y-%m-%d'` |

RESPONSE: success

```
[
    {
        "day": 2,
        "date": " 2 de Julio de 2024",
        "available_hours": [
            "03:00",
            "04:00",
            "05:00",
            ...
        ],
        "users": [
            {
                "id": 1,
                "name": "Carmen Garibay",
                "hours": [
                    "03:00",
                    "04:00",
                    "05:00",
                    ...
                ],
                "total": 0
            },
            ...
        ]
    },
    ...
]
```

#### Listar el total de horas implementadas por cada usuario semanalmente

```http
  GET /services/total_used_hours_per_user/${id}?week=${week}&date=${date}
```

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |
| `week`      | `integer` | **Required**. Número de la semana |
| `date`      | `string` | **Required**. Fecha en formato `'%Y-%m-%d'` |

RESPONSE: success

```
[
    {
        "user": {
            "name": "Carmen Garibay",
            "id": 1
        },
        "hours": [],
        "total": 0
    },
    ...
]
```

#### Listar el total de horas implementadas por cada usuario semanalmente

```http
  GET /services/availabilities_hours/${id}
```

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id del servicio |

RESPONSE: success

```
[
    {
        "day": 2,
        "hours": [
            "03:00",
            "04:00",
            "05:00",
            ...
        ]
    },
    ...
]
```

### Peticiones para los otros modelos
Para los otros modelos se implemento el CRUD básico. Como ejemplo se deja el CRUD de *Services*

#### Service

| Header | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Autorization` | `string` | **Required** Bearer + token |

|HTTP Method|URL|Description|
|---|---|---|
|`POST`|/services | Crear nuevo |
|`PUT`|/services/{service_id} | Actualizar por ID |
|`GET`|/services/{service_id} | Ver ID |
|`DELETE`|/services/{service_id} | Eliminar por ID |

### Status Codes

Lista de codigos `HTTP` implementados en el API:

| Status Code | Description |
| :--- | :--- |
| 200 | `OK` |
| 201 | `CREATED` |
| 400 | `BAD REQUEST` |
| 401 | `UNAUTHORIZED` |
| 404 | `NOT FOUND` |
| 422 | `UNPROCESSABLE CONTENT` |
| 500 | `INTERNAL SERVER ERROR` |

### Días de la semana

Ids implementados para los días de la semana

| Code | Value |
| :--- | :--- |
| 1 | `L` |
| 2 | `M` |
| 3 | `X` |
| 4 | `J` |
| 5 | `V` |
| 6 | `S` |
| 7 | `D` |

## Instalación

Para instalar el proyecto solo es necesario instalar los paquetes del bundle y los comandos para generar la db y ejecutar los seeds.

```bash
  bundle install
  rails db:create
  rails db:migrate
  rails db:seed **optional**
```

Una vez instalado el proyecto es necesario obtener la key para la codificacion de los tokens JWT. Esta se obtiene con el siguiente comando:

```bash
  bundle exec rails secret
```

> Nota: Se debe tener creado un usuario y una base de datos previamente
## Variables de entorno

En la raíz del proyecto debe ir el archivo .env con las siguientes variables.

`DATABASE_USER`

`DATABASE_PASSWORD`

`JWT_KEY`


![Modelo entidad relacion](model_ER.svg)


