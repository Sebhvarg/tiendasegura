const mongoose = require('mongoose');

const connections = new Map();

/**
 * Obtiene (o crea) una conexión mongoose para la base de datos indicada.
 * Usa un singleton por `dbName` para evitar múltiples conexiones redundantes.
 * @param {string|null} dbName Nombre de la base de datos (si null usa la conexión por defecto)
 * @returns {Promise<mongoose.Connection>} conexión ya establecida
 */
async function getConnection(dbName = null) {
  const key = dbName || '__default__';

  if (connections.has(key)) {
    const existing = connections.get(key);
    if (existing.readyState === 1) return existing; // connected
    try {
      await existing.asPromise();
      return existing;
    } catch (err) {
      // Si la conexión previa falló, eliminarla y crear una nueva
      connections.delete(key);
    }
  }

  const uri = process.env.MONGODB_URI;
  if (!uri) throw new Error('MONGODB_URI no está definida en las variables de entorno');

  const conn = mongoose.createConnection(uri, dbName ? { dbName } : {});
  await conn.asPromise();

  connections.set(key, conn);
  return conn;
}

async function closeAllConnections() {
  const closes = [];
  for (const conn of connections.values()) {
    closes.push(conn.close().catch(() => {}));
  }
  await Promise.all(closes);
  connections.clear();
}

module.exports = {
  getConnection,
  closeAllConnections
};
