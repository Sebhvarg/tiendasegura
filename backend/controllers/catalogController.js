const Catalog = require('../models/catalog');

async function getCatalog(req, res, next) {
  try {
    // traer todos los catálogos
    const catalogs = await Catalog.find().populate('products').exec();
    res.json(catalogs);
  } catch (err) {
    next(err);
  } 
};

module.exports = {
  getCatalog,
};