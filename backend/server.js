require('dotenv').config({ path: __dirname + '/.env' });
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Inicializar app
const app = express();

// Conectar a MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rutas
const authRoutes = require('./routes/auth');
const databaseRoutes = require('./routes/database');
const productRoutes = require('./routes/products');
const shoppingCartRoutes = require('./routes/shoppingCart');
const listRoutes = require('./routes/list');
const catalogRoutes = require('./routes/catalog');
const orderRoutes = require('./routes/order');
const searchHistoryRoutes = require('./routes/searchHistory');


app.use('/api/auth', authRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/catalogs', catalogRoutes);
app.use('/api/lists', listRoutes); 
app.use('/api/shopping-carts', shoppingCartRoutes);
app.use('/api/search-history', searchHistoryRoutes);
app.use('/api/', databaseRoutes);
app.use('/api/products', productRoutes);



// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ 
    message: 'API de TiendaSegura funcionando correctamente',
    version: '1.0.0'
  });
});

// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false,
    message: 'Error en el servidor',
    error: process.env.NODE_ENV === 'development' ? err.message : {}
  });
});

// Puerto
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
  console.log(`Entorno: ${process.env.NODE_ENV}`);
});
