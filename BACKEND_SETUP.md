# 🛒 TiendaSegura - Guía Completa de Backend y MongoDB

Este documento te guiará paso a paso para configurar y usar el backend con MongoDB para tu aplicación Flutter.

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Instalación de MongoDB](#instalación-de-mongodb)
3. [Configuración del Backend](#configuración-del-backend)
4. [Configuración de Flutter](#configuración-de-flutter)
5. [Pruebas de la API](#pruebas-de-la-api)
6. [Uso desde Flutter](#uso-desde-flutter)

---

## 📦 Requisitos Previos

- **Node.js** (v16 o superior) - [Descargar aquí](https://nodejs.org/)
- **MongoDB** (local o cuenta en MongoDB Atlas)
- **Flutter** (ya instalado en tu proyecto)

---

## 🗄️ Instalación de MongoDB

### Opción 1: MongoDB Local (Windows)

1. **Descargar MongoDB Community Server**:
   - Ve a [MongoDB Download Center](https://www.mongodb.com/try/download/community)
   - Descarga la versión para Windows
   - Ejecuta el instalador y sigue las instrucciones

2. **Verificar instalación**:
   ```bash
   mongod --version
   ```

3. **Iniciar MongoDB**:
   ```bash
   # MongoDB se inicia automáticamente como servicio en Windows
   # Para verificar que está corriendo:
   net start MongoDB
   ```

### Opción 2: MongoDB Atlas (en la nube - RECOMENDADO)

1. **Crear cuenta gratuita**:
   - Ve a [MongoDB Atlas](https://www.mongodb.com/cloud/atlas/register)
   - Regístrate con tu email

2. **Crear un cluster gratuito**:
   - Selecciona el plan "Shared" (gratis)
   - Elige una región cercana
   - Crea el cluster

3. **Configurar acceso**:
   - En "Database Access", crea un usuario con contraseña
   - En "Network Access", agrega tu IP o permite acceso desde cualquier IP (0.0.0.0/0)

4. **Obtener Connection String**:
   - Click en "Connect" en tu cluster
   - Selecciona "Connect your application"
   - Copia el connection string:
   ```
   mongodb+srv://<usuario>:<password>@cluster.mongodb.net/tiendasegura
   ```

---

## ⚙️ Configuración del Backend

1. **Navegar a la carpeta backend**:
   ```bash
   cd backend
   ```

2. **Instalar dependencias**:
   ```bash
   npm install
   ```

3. **Configurar variables de entorno**:
   - Edita el archivo `.env` en la carpeta `backend`:

   **Para MongoDB Local**:
   ```env
   MONGODB_URI=mongodb://localhost:27017/tiendasegura
   PORT=3000
   NODE_ENV=development
   JWT_SECRET=tiendasegura_secret_key_2025
   JWT_EXPIRE=7d
   ```

   **Para MongoDB Atlas**:
   ```env
   MONGODB_URI=mongodb+srv://<tu_usuario>:<tu_password>@cluster.mongodb.net/tiendasegura
   PORT=3000
   NODE_ENV=development
   JWT_SECRET=tiendasegura_secret_key_2025
   JWT_EXPIRE=7d
   ```

4. **Iniciar el servidor**:
   ```bash
   # Modo desarrollo (con auto-reload)
   npm run dev

   # O modo normal
   npm start
   ```

5. **Verificar que funciona**:
   - Abre tu navegador en: `http://localhost:3000`
   - Deberías ver: `{"message": "API de TiendaSegura funcionando correctamente"}`

---

## 📱 Configuración de Flutter

1. **Instalar dependencias de Flutter**:
   ```bash
   # Desde la raíz del proyecto (no desde backend)
   cd ..
   flutter pub get
   ```

2. **Configurar la URL del API**:
   - Abre `lib/model/API/api_config.dart`
   - Actualiza la `baseUrl` según tu caso:

   ```dart
   // Para emulador Android:
   static const String baseUrl = 'http://10.0.2.2:3000/api';
   
   // Para dispositivo físico (reemplaza con tu IP local):
   static const String baseUrl = 'http://192.168.1.100:3000/api';
   
   // Para iOS Simulator o web:
   static const String baseUrl = 'http://localhost:3000/api';
   ```

3. **Encontrar tu IP local** (para dispositivos físicos):
   ```bash
   # Windows
   ipconfig
   # Busca "IPv4 Address" en tu conexión WiFi/Ethernet

   # Mac/Linux
   ifconfig
   # Busca "inet" en tu conexión activa
   ```

---

## 🧪 Pruebas de la API

### Usando PowerShell (Windows):

#### 1. Registrar un usuario:
```powershell
$body = @{
    nombre = "Juan Pérez"
    email = "juan@example.com"
    password = "password123"
    rol = "cliente"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/users/register" -Method Post -Body $body -ContentType "application/json"
```

#### 2. Login:
```powershell
$body = @{
    email = "juan@example.com"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:3000/api/users/login" -Method Post -Body $body -ContentType "application/json"
$token = $response.data.token
echo "Token: $token"
```

#### 3. Obtener productos:
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/products" -Method Get
```

---

## 📲 Uso desde Flutter

### Ejemplo 1: Registro de Usuario

```dart
import 'package:tiendasegura/model/API/auth_service.dart';

final authService = AuthService();

// Registrar usuario
final result = await authService.register(
  nombre: 'Juan Pérez',
  email: 'juan@example.com',
  password: 'password123',
  rol: 'cliente',
);

if (result['success']) {
  print('Usuario registrado: ${result['data']}');
} else {
  print('Error: ${result['message']}');
}
```

### Ejemplo 2: Login

```dart
final result = await authService.login(
  email: 'juan@example.com',
  password: 'password123',
);

if (result['success']) {
  print('Login exitoso');
  print('Token: ${result['data']['token']}');
} else {
  print('Error: ${result['message']}');
}
```

### Ejemplo 3: Obtener Productos

```dart
import 'package:tiendasegura/model/API/product_service.dart';

final productService = ProductService();

// Obtener todos los productos
final result = await productService.getProducts();

if (result['success']) {
  List<Product> products = result['data'];
  print('Total de productos: ${products.length}');
} else {
  print('Error: ${result['message']}');
}
```

### Ejemplo 4: Crear Tienda (vendedor)

```dart
import 'package:tiendasegura/model/API/store_service.dart';

final storeService = StoreService();

final result = await storeService.createStore(
  nombre: 'Mi Tienda',
  descripcion: 'Descripción de mi tienda',
  direccion: {
    'calle': 'Av. Principal 123',
    'ciudad': 'Ciudad',
    'estado': 'Estado',
    'codigoPostal': '12345',
  },
  telefono: '5551234567',
  email: 'tienda@example.com',
);

if (result['success']) {
  print('Tienda creada: ${result['data']}');
} else {
  print('Error: ${result['message']}');
}
```

---

## 🎯 Estructura del Proyecto

```
tiendasegura/
├── backend/                    # Backend con Node.js y MongoDB
│   ├── config/
│   │   └── db.js              # Configuración de MongoDB
│   ├── controllers/           # Lógica de negocio
│   │   ├── userController.js
│   │   ├── productController.js
│   │   └── storeController.js
│   ├── middleware/
│   │   └── auth.js           # Autenticación JWT
│   ├── models/               # Modelos de MongoDB
│   │   ├── User.js
│   │   ├── Product.js
│   │   └── Store.js
│   ├── routes/               # Rutas de la API
│   │   ├── userRoutes.js
│   │   ├── productRoutes.js
│   │   └── storeRoutes.js
│   ├── .env                  # Variables de entorno
│   ├── package.json
│   └── server.js             # Punto de entrada
│
├── lib/
│   ├── model/
│   │   ├── API/             # Servicios de API
│   │   │   ├── api_config.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── product_service.dart
│   │   │   └── store_service.dart
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   └── store_model.dart
│   ├── views/               # Vistas de Flutter
│   └── main.dart
└── pubspec.yaml
```

---

## 🚨 Solución de Problemas

### Error: "Cannot connect to MongoDB"
- Verifica que MongoDB esté corriendo: `net start MongoDB`
- Verifica la cadena de conexión en `.env`
- Para Atlas, verifica que tu IP esté en la whitelist

### Error: "Connection refused" desde Flutter
- Verifica que el backend esté corriendo en `http://localhost:3000`
- Usa la IP correcta según tu plataforma (ver sección de configuración)
- Verifica que no haya firewall bloqueando el puerto 3000

### Error: "Cannot find module"
- Asegúrate de estar en la carpeta `backend`
- Ejecuta: `npm install`

---

## 📚 Recursos Adicionales

- [Documentación de MongoDB](https://docs.mongodb.com/)
- [Express.js Guide](https://expressjs.com/)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [JWT Introduction](https://jwt.io/introduction)

---

## 🎉 ¡Listo!

Ahora tienes un backend completo con MongoDB conectado a tu aplicación Flutter. Puedes:

1. ✅ Registrar y autenticar usuarios
2. ✅ Gestionar productos
3. ✅ Crear y administrar tiendas
4. ✅ Todo con seguridad JWT

Para más detalles técnicos, consulta el README en la carpeta `backend/`.
