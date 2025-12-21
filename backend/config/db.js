const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // Mongoose maneja automáticamente la conexión con MongoDB Atlas
    const conn = await mongoose.connect(process.env.MONGODB_URI);

    console.log(`✅ MongoDB Conectado: ${conn.connection.host}`);
    console.log(`📦 Base de datos: ${conn.connection.name}`);
    
    // Verificar conexión enviando un ping
    await mongoose.connection.db.admin().ping();
    console.log('🎯 Ping exitoso - Conexión verificada');
  } catch (error) {
    console.error(`❌ Error de conexión a MongoDB: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
