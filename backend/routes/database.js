const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const { getConnection } = require('../config/connectionPool');
const db = process.env.BASEDEDATOS || 'test_ts';


router.get(`/database/${db}/collections`, async (req, res) => {
  try {
    // Usar singleton para obtener/crear la conexión a la base de datos
    const conn = await getConnection(db);
    const collections = await conn.db.listCollections().toArray();
    res.json({
      success: true,
      database: db, 
      totalCollections: collections.length,
      collections: collections.map(col => col.name)
    });
    // not closing the connection because we reuse singleton connections
  } catch (error) {
    res.status(500).json({
      success: false,
      message: `Error al obtener colecciones de la base de datos ${db}`,
      error: error.message
    });
  }
}); 

router.get(`/database/${db}/collections/products/count`, async (req, res) => {
  try {
    const conn = await getConnection(db);
    const productSchema = new mongoose.Schema({}, { strict: false });
    const Product = conn.models.Product || conn.model('Product', productSchema, 'products');
    const count = await Product.countDocuments();
    res.json({
      success: true,
      database: db,
      collection: 'products',
      totalDocuments: count
    });
    // not closing the connection because we reuse singleton connections
  }
  catch (error) {
    res.status(500).json({
      success: false,
      message: `Error al contar documentos en la colección products de la base de datos ${db}`,
      error: error.message
    });
  }
});

module.exports = router;
