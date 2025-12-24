const SearchHistory = require('../models/searchHistory');
const Catalog = require('../models/catalog');
const Product = require('../models/product');
const Shop = require('../models/shop');

/**
 * Traer todos los catálogos (YA EXISTENTE)
 */
async function getCatalog(req, res, next) {
  try {
    const catalogs = await Catalog.find()
      .populate('products')
      .exec();
    res.json(catalogs);
  } catch (err) {
    next(err);
  }
}

/**
 * 🔍 Buscar productos y tiendas
 * GET /api/catalog/search?q=texto
 */
async function searchCatalog(req, res, next) {
  try {
    const { q, clientId } = req.query;

    if (!q) {
      return res.status(400).json({
        message: 'Debe ingresar un texto para buscar'
      });
    }

    // GUARDAR HISTORIAL DE BÚSQUEDA
    if (clientId) {
      await SearchHistory.create({
        client: clientId,
        query: q
      });
    }

    const regex = new RegExp(q, 'i');

    const products = await Product.find({
      $or: [
        { name: regex },
        { brand: regex },
        { description: regex }
      ]
    });

    const shops = await Shop.find({
      name: regex
    });

    res.json({ products, shops });

  } catch (err) {
    next(err);
  }
}

module.exports = {
  getCatalog,
  searchCatalog
};
