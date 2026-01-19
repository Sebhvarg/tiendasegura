# TiendaSegura

Una aplicación móvil multiplataforma para compra y venta de productos de forma segura. Construida con **Flutter** para el frontend y **Node.js + Express + MongoDB** para el backend.

## Descripción del Proyecto

TiendaSegura es una plataforma de comercio electrónico completa que permite:

- **Clientes**: Explorar catálogos, crear listas de deseos, carrito de compras, realizar pedidos y gestionar historial de compras
- **Vendedores**: Crear y gestionar tiendas, registrar productos, ver pedidos y gestionar inventario
- **Búsqueda**: Búsqueda avanzada de productos con historial de búsquedas
- **Autenticación**: Sistema seguro de login/registro con autenticación JWT
- **Verificación de cédula**: Verificación de cédula para vendedores y clientes
- **Uso de Expresiones Regulares**: Validación de datos con expresiones regulares
- **Uso de Web Scraping**: Extracción de datos de sitios web

## Características Principales

- ✅ Autenticación y autorización con JWT
- ✅ Gestión de múltiples productos para vendedores
- ✅ Catálogo de productos con búsqueda y filtros
- ✅ Carrito de compras
- ✅ Sistema de órdenes y pedidos
- ✅ Interfaz multiplataforma (Android, iOS, Web)
- ✅ Validación de datos del lado del servidor
- ✅ Almacenamiento de imágenes y web scraping

##Arquitectura del Proyecto

### Frontend (Dart/Flutter)

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

### Backend (Node.js/Express/MongoDB/ JavaScript)

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

## Requisitos Previos

### Frontend (Flutter)

- Flutter SDK 3.10.4 o superior
- Dart SDK (incluido con Flutter)
- Android Studio / Xcode (para emuladores)

### Backend (Node.js)

- Node.js 14.0 o superior
- npm o yarn
- MongoDB 4.4 o superior

## Instalación

### Backend

```bash
cd backend
npm install
```

**Configurar variables de entorno** - Crear archivo `.env`:

```
# MONGODB conexion string
MONGODB_URI=mongodb+srv://sebhvarg_db_user:LZuIurRVQWtSayoV@tiendasegura.2x0mhnp.mongodb.net/?appName=tiendasegura
BASE_DE_DATOS=test_ts

# Configuracion del servidor
PORT=3000
NODE_ENV=development

# JWT Configuracion
JWT_SECRET=tiendasegura_secret_key_2025
JWT_EXPIRE=7d

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
flutter build web          # Web
```

## Usuarios de prueba

- Cliente:
  - Correo: andres@email.com
  - Contraseña: Andres1234!

- Vendedor:
  - Correo: silk@email.com
  - Contraseña: Silk1234!

## Plataformas Soportadas

- ✅ Android
- ✅ Web

## Seguridad

- Autenticación JWT para proteger endpoints
- Hash de contraseñas con bcryptjs
- CORS configurado
- Validación de datos en servidor
- Middleware de autenticación

## Stack Tecnológico

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

## Colaboradores

- **Sebastian Holguin** - sebhvarg@espol.edu.ec
- **Derian Baque** - dfbaque@espol.edu.ec
- **Carlos Ronquillo** - carrbrus@espol.edu.ec

---

**Desarrollado con ❤️ para hacer el comercio más seguro**
