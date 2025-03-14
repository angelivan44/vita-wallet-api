# API Documentation

## Ejemplo de Uso de los Endpoints

### Gestión de Usuarios

#### Crear un Usuario
Crea un nuevo usuario con wallets predeterminados en USD y BTC.
- **URL:** `/users`
- **Método:** `POST`
- **Cuerpo de la Solicitud:**
  ```json
  {
    "user": {
        "email": "usuario@ejemplo.com",
        "username": "angel"
    }
  }
  ```
- **Respuesta Exitosa:**
  - **Código:** 201 Created
  - **Contenido:**
  ```json
  {
    "id": 3,
    "email": "usuario2@ejemplo.com",
    "username": "angel2"
  }
  ```
- **Respuesta de Error:**
  - **Código:** 422 Unprocessable Entity
  - **Contenido:**
  ```json
  {
    "email": [
        "has already been taken"
    ],
    "username": [
        "has already been taken"
    ]
  }
  ```



### Tasas de Cambio

#### Obtener Tasa de Cambio de BTC a USD
Recupera la tasa de cambio actual de BTC a USD.
- **URL:** `/exchanges/btc_to_usd_price`
- **Método:** `GET`
- **Respuesta Exitosa:**
  - **Código:** 200 OK
  - **Contenido:**
  ```json
  {
    "currency": "BTC",
    "price": "0.00001198"
  }
  ```

### Transacciones

#### Crear una Transacción
Crea una nueva transacción de conversión de moneda entre wallets.
- **URL:** `/users/:user_id/transactions`
- **Método:** `POST`
- **Parámetros de URL:** `user_id=[integer]` (ID del Usuario)
- **Cuerpo de la Solicitud:**
  ```json
  {
    "amount_from": "200",
    "currency_from": "USD",
    "currency_to":"BTC"
  }
  ```
- **Respuesta Exitosa:**
  - **Código:** 201 Created
  - **Contenido:**
  ```json
  {
    "id": 4,
    "user_id": 1,
    "currency_from": "USD",
    "currency_to": "BTC",
    "amount_from": 200.0,
    "amount_to": 0.002396,
    "exchange_rate": 1.198e-05,
    "created_at": "2025-03-14T13:07:07.547Z",
    "updated_at": "2025-03-14T13:07:07.547Z"
  }
  ```
- **Respuestas de Error:**
  - **Código:** 422 Unprocessable Entity (Parámetros Inválidos)
  - **Código:** 422 Unprocessable Entity (Fondos Insuficientes)
  - **Código:** 422 Unprocessable Entity (Tasa de Cambio Inválida)

#### Listar Transacciones del Usuario
Recupera todas las transacciones de un usuario.
- **URL:** `/users/:user_id/transactions`
- **Método:** `GET`
- **Parámetros de URL:** `user_id=[integer]` (ID del Usuario)
- **Respuesta Exitosa:**
  - **Código:** 200 OK
  - **Contenido:**
  ```json
  [
    {
        "id": 1,
        "user_id": 1,
        "currency_from": "USD",
        "currency_to": "BTC",
        "amount_from": 100.0,
        "amount_to": 0.001216,
        "exchange_rate": 1.216e-05,
        "created_at": "2025-03-14T03:01:01.425Z",
        "updated_at": "2025-03-14T03:01:01.425Z"
    },
    {
        "id": 2,
        "user_id": 1,
        "currency_from": "USD",
        "currency_to": "BTC",
        "amount_from": 200.0,
        "amount_to": 0.002432,
        "exchange_rate": 1.216e-05,
        "created_at": "2025-03-14T03:01:20.012Z",
        "updated_at": "2025-03-14T03:01:20.012Z"
    },
    {
        "id": 3,
        "user_id": 1,
        "currency_from": "USD",
        "currency_to": "BTC",
        "amount_from": 200.0,
        "amount_to": 0.0024360000000000002,
        "exchange_rate": 1.218e-05,
        "created_at": "2025-03-14T03:30:08.198Z",
        "updated_at": "2025-03-14T03:30:08.198Z"
    }
  ]
  ```

#### Obtener Detalles de una Transacción
Recupera los detalles de una transacción específica.
- **URL:** `/users/:user_id/transactions/:id`
- **Método:** `GET`
- **Parámetros de URL:**
  - `user_id=[integer]` (ID del Usuario)
  - `id=[integer]` (ID de la Transacción)
- **Respuesta Exitosa:**
  - **Código:** 200 OK
  - **Contenido:**
  ```json
  {
    "id": 1,
    "user_id": 1,
    "currency_from": "USD",
    "currency_to": "BTC",
    "amount_from": 100.0,
    "amount_to": 0.001216,
    "exchange_rate": 1.216e-05,
    "created_at": "2025-03-14T03:01:01.425Z",
    "updated_at": "2025-03-14T03:01:01.425Z"
  }
  ```
- **Respuesta de Error:**
  - **Código:** 404 Not Found
  - **Contenido:**
  ```json
  {
    "error": "Transacción no encontrada"
  }
  ```

## Notas Importantes
- **Creación de Wallets:** Cuando se crea un usuario, se crean automáticamente dos wallets:
  - Wallet en USD con un saldo inicial de 1000
  - Wallet en BTC con un saldo inicial de 0
- **Procesamiento de Transacciones:**
  - Las transacciones solo tendrán éxito si el usuario tiene fondos suficientes en la wallet de origen.
  - Tras una transacción exitosa, el saldo de la wallet de origen se reduce y el saldo de la wallet de destino se incrementa.
