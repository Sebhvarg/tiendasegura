const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // Mongoose maneja automáticamente la conexión con MongoDB Atlas
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      dbName: process.env.BASE_DE_DATOS,
      serverSelectionTimeoutMS: 30000,
      socketTimeoutMS: 30000,
      retryWrites: true,
      w: 'majority'
    });
    console.log(`✅ MongoDB Conectado: ${conn.connection.host}`);
    console.log(`📦 Base de datos: ${conn.connection.name}`);
  } catch (error) {
    console.error(`❌ Error de conexión a MongoDB: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
