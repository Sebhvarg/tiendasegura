# TiendaSegura 🛒

Una aplicación móvil multiplataforma para compra y venta de productos de forma segura. Construida con **Flutter** para el frontend y **Node.js + Express + MongoDB** para el backend.

## 📋 Descripción del Proyecto

TiendaSegura es una plataforma de comercio electrónico completa que permite:

- **Clientes**: Explorar catálogos, crear listas de deseos, carrito de compras, realizar pedidos y gestionar historial de compras
- **Vendedores**: Crear y gestionar tiendas, registrar productos, ver pedidos y gestionar inventario
- **Búsqueda**: Búsqueda avanzada de productos con historial de búsquedas
- **Autenticación**: Sistema seguro de login/registro con autenticación JWT

## 🚀 Características Principales

- ✅ Autenticación y autorización con JWT
- ✅ Gestión de múltiples tiendas y vendedores
- ✅ Catálogo de productos con búsqueda y filtros
- ✅ Carrito de compras y listas de deseos
- ✅ Sistema de órdenes y pedidos
- ✅ Interfaz multiplataforma (Android, iOS, Web)
- ✅ Validación de datos del lado del servidor
- ✅ Almacenamiento de imágenes y web scraping

## 🏗️ Arquitectura del Proyecto

### Frontend (Flutter)
```
lib/
├── main.dart                    # Punto de entrada
├── views/                       # Pantallas UI
│   ├── inicio.dart             # Pantalla de inicio
│   ├── catalogo.dart           # Catálogo de productos
│   ├── carrito.dart            # Carrito de compras
│   ├── tiendas.dart            # Listado de tiendas
│   ├── inicio_sesion.dart      # Login
│   ├── registro.dart           # Registro de usuarios
│   ├── pedidos_cliente.dart    # Pedidos del cliente
│   ├── pedidos_tienda.dart     # Pedidos de la tienda
│   └── ...
├── ViewModel/                   # Lógica de negocio
│   ├── auth_viewmodel.dart     # Autenticación
│   └── carrito_viewmodel.dart  # Carrito
├── model/                       # Modelos de datos
│   ├── auth_models.dart
│   ├── producto.dart
│   └── API/                     # Modelos API
├── themes/                      # Temas y estilos
└── assets/                      # Recursos estáticos
```

### Backend (Node.js/Express)
```
backend/
├── server.js                    # Punto de entrada
├── config/                      # Configuración
│   ├── db.js                   # Conexión a MongoDB
│   └── connectionPool.js       # Pool de conexiones
├── controllers/                 # Lógica de negocio
│   ├── authController.js
│   ├── productController.js
│   ├── orderController.js
│   ├── shopController.js
│   ├── shoppingCartController.js
│   └── ...
├── models/                      # Esquemas MongoDB
│   ├── user.js
│   ├── product.js
│   ├── order.js
│   ├── shop.js
│   └── ...
├── routes/                      # Endpoints API
├── middleware/                  # Middlewares (autenticación, etc.)
├── services/                    # Servicios externos
└── enum/                        # Enumeraciones
```

## 💻 Requisitos Previos

### Frontend (Flutter)
- Flutter SDK 3.10.4 o superior
- Dart SDK (incluido con Flutter)
- Android Studio / Xcode (para emuladores)

### Backend (Node.js)
- Node.js 14.0 o superior
- npm o yarn
- MongoDB 4.4 o superior

## 📦 Instalación

### Backend

```bash
cd backend
npm install
```

**Configurar variables de entorno** - Crear archivo `.env`:
```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/tiendasegura
JWT_SECRET=tu_clave_secreta_aqui
```

**Iniciar servidor**:
```bash
# Desarrollo
npm run dev

# Producción
npm start
```

### Frontend

```bash
# Instalar dependencias
flutter pub get

# Conectar dispositivo o iniciar emulador
flutter devices

# Ejecutar aplicación
flutter run

# Compilar para plataformas específicas
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## 🔌 API Endpoints

### Autenticación
- `POST /api/auth/register` - Registrar nuevo usuario
- `POST /api/auth/login` - Login de usuario
- `POST /api/auth/logout` - Logout

### Productos
- `GET /api/products` - Listar todos los productos
- `GET /api/products/:id` - Obtener detalle de producto
- `POST /api/products` - Crear nuevo producto (vendedor)
- `PUT /api/products/:id` - Actualizar producto
- `DELETE /api/products/:id` - Eliminar producto

### Tiendas
- `GET /api/shops` - Listar tiendas
- `POST /api/shops` - Crear tienda
- `GET /api/shops/:id` - Obtener detalles tienda

### Órdenes
- `GET /api/orders` - Obtener órdenes del usuario
- `POST /api/orders` - Crear nueva orden
- `PUT /api/orders/:id` - Actualizar estado de orden

### Carrito
- `GET /api/cart` - Obtener carrito
- `POST /api/cart/items` - Agregar item al carrito
- `DELETE /api/cart/items/:id` - Remover item del carrito

### Búsqueda
- `GET /api/search` - Buscar productos
- `GET /api/search/history` - Obtener historial de búsquedas

## 📱 Plataformas Soportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ⚡ Linux (experimental)
- ⚡ Windows (experimental)
- ⚡ macOS (experimental)

## 🔐 Seguridad

- Autenticación JWT para proteger endpoints
- Hash de contraseñas con bcryptjs
- CORS configurado
- Validación de datos en servidor
- Middleware de autenticación

## 📊 Stack Tecnológico

### Frontend
- **Flutter** 3.10.4
- **Provider** - Gestión de estado
- **Dart** 3.10.4

### Backend
- **Express.js** 4.18.2
- **MongoDB** 8.0.3
- **JWT** 9.0.2
- **bcryptjs** 2.4.3
- **Multer** 2.0.2 (manejo de archivos)
- **Cheerio** 1.1.2 (web scraping)
- **CORS** 2.8.5

## 📞 Soporte

Para reportar problemas o sugerencias, abre un issue en el repositorio.
## 👥 Colaboradores

- **Sebastian Holguin** - sebhvarg@espol.edu.ec
- **Derian Baque** - dfbaque@espol.edu.ec
- **Carlos Ronquillo** - carrbrus@espol.edu.ec
---

**Desarrollado con ❤️ para hacer el comercio más seguro**
