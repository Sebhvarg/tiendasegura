# Backend TiendaSegura

Backend API REST para la aplicación TiendaSegura, construido con Node.js, Express y MongoDB.

## 🚀 Características

- **Autenticación JWT**: Sistema de registro y login seguro
- **Roles de usuario**: Cliente, Vendedor y Admin
- **CRUD completo**: Usuarios, Productos y Tiendas
- **MongoDB**: Base de datos NoSQL
- **Validaciones**: Validación de datos con Mongoose
- **Seguridad**: Encriptación de contraseñas con bcrypt

## 📋 Requisitos previos

- Node.js (v16 o superior)
- MongoDB (local o MongoDB Atlas)
- npm o yarn

## 🔧 Instalación

1. Navega a la carpeta backend:
```bash
cd backend
```

2. Instala las dependencias:
```bash
npm install
```

3. Configura las variables de entorno:
   - Copia `.env.example` a `.env`
   - Actualiza las variables según tu configuración:
```
MONGODB_URI=mongodb://localhost:27017/tiendasegura
PORT=3000
JWT_SECRET=tu_clave_secreta_segura
JWT_EXPIRE=7d
```

4. Inicia MongoDB (si es local):
```bash
# Windows
mongod

# Linux/Mac
sudo systemctl start mongod
```

## 🚀 Uso

### Modo desarrollo (con auto-reload):
```bash
npm run dev
```

### Modo producción:
```bash
npm start
```

El servidor estará corriendo en `http://localhost:3000`

## 📚 Endpoints de la API

### Usuarios
- `POST /api/users/register` - Registrar nuevo usuario
- `POST /api/users/login` - Login de usuario
- `GET /api/users/profile` - Obtener perfil (protegido)
- `PUT /api/users/profile` - Actualizar perfil (protegido)
- `GET /api/users` - Listar usuarios (admin)
- `DELETE /api/users/:id` - Eliminar usuario (admin)

### Productos
- `GET /api/products` - Listar productos (público)
- `GET /api/products/:id` - Obtener producto por ID
- `GET /api/products/store/:storeId` - Productos por tienda
- `POST /api/products` - Crear producto (vendedor)
- `PUT /api/products/:id` - Actualizar producto (vendedor)
- `DELETE /api/products/:id` - Eliminar producto (vendedor)

### Tiendas
- `GET /api/stores` - Listar tiendas (público)
- `GET /api/stores/:id` - Obtener tienda por ID
- `GET /api/stores/my/store` - Mi tienda (vendedor)
- `POST /api/stores` - Crear tienda (vendedor)
- `PUT /api/stores/:id` - Actualizar tienda (vendedor)
- `DELETE /api/stores/:id` - Eliminar tienda (admin)

## 🔑 Autenticación

Para rutas protegidas, incluye el token JWT en el header:
```
Authorization: Bearer <tu_token_jwt>
```

## 📦 Estructura del proyecto

```
backend/
├── config/
│   └── db.js              # Configuración de MongoDB
├── controllers/
│   ├── userController.js
│   ├── productController.js
│   └── storeController.js
├── middleware/
│   └── auth.js            # Middleware de autenticación
├── models/
│   ├── User.js
│   ├── Product.js
│   └── Store.js
├── routes/
│   ├── userRoutes.js
│   ├── productRoutes.js
│   └── storeRoutes.js
├── .env
├── .env.example
├── .gitignore
├── package.json
└── server.js              # Punto de entrada
```

## 🧪 Ejemplo de uso

### Registrar usuario:
```bash
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Juan Pérez",
    "email": "juan@example.com",
    "password": "password123",
    "rol": "cliente"
  }'
```

### Login:
```bash
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'
```

## 🌐 MongoDB Atlas (Opcional)

Si prefieres usar MongoDB en la nube:

1. Crea una cuenta en [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Crea un cluster gratuito
3. Obtén tu connection string
4. Actualiza `MONGODB_URI` en `.env`:
```
MONGODB_URI=mongodb+srv://<usuario>:<password>@cluster.mongodb.net/tiendasegura?retryWrites=true&w=majority
```

## 🛠️ Tecnologías

- **Express.js** - Framework web
- **MongoDB** - Base de datos
- **Mongoose** - ODM para MongoDB
- **JWT** - Autenticación
- **bcryptjs** - Encriptación de contraseñas
- **cors** - Manejo de CORS
- **dotenv** - Variables de entorno

## 📝 Notas

- El puerto por defecto es 3000, puedes cambiarlo en el archivo `.env`
- Asegúrate de que MongoDB esté corriendo antes de iniciar el servidor
- Para producción, usa una clave secreta fuerte en `JWT_SECRET`
