const Product = require('../models/product');
const Catalog = require('../models/catalog');
const List = require('../models/list');
const { searchProductImage } = require('../services/imageScraperService');

async function createProduct(req, res, next) {
  try {
    const payload = req.body;
    
    // Si no se proporciona imageUrl, buscar automáticamente
    if (!payload.imageUrl && payload.name) {
      console.log(`🔍 Buscando imagen para: ${payload.name} ${payload.brand || ''} ${payload.netContent ?? ''} ${payload.netContentUnit ?? ''}`);
      const imageUrl = await searchProductImage(
        payload.name,
        payload.brand || '',
        payload.netContent,
        payload.netContentUnit
      );
      if (imageUrl) {
        payload.imageUrl = imageUrl;
      }
    }
    
    const product = await Product.createProduct(payload);
    res.status(201).json(product);
  } catch (err) {
    next(err);
  }
}
async function getProduct(req, res, next) {
  try {
    const { id } = req.params;
    const product = await Product.findById(id).exec();
    if (!product) return res.status(404).json({ error: 'Product not found' });
    res.json(product);
  } catch (err) {
    next(err);
  }
}
async function getListProducts(req, res, next) {
    try {
    const list = await Product.find().exec();
    res.json(list);
    } catch (err) {
      next(err);
    }
}

// agregar al catalogo
async function addToCatalog(req, res, next) {
  try {
    const { catalogId, productId } = req.params;
    const catalog = await Catalog.findById(catalogId);
    if (!catalog) return res.status(404).json({ error: 'Catalog not found' });
    catalog.products.push(productId);
    await catalog.save();
    res.json(catalog);
  }
  catch (err) {
    next(err);
  }
}

async function addToList(req, res, next) {
  try {
    const { listId, productId } = req.params;
    const list = await List.findById(listId);
    if (!list) return res.status(404).json({ error: 'listlog not found' });
    list.products.push(productId);
    await list.save();
    res.json(list);
  }
  catch (err) {
    next(err);
  }
}

module.exports = {
  createProduct,
  getProduct,
  getListProducts,
  addToCatalog,
  addToList,
};