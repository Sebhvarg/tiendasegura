const express = require("express");
const router = express.Router();

const Shop = require("../models/shop");
const Product = require("../models/product");
const Catalog = require("../models/catalog");

const { protect } = require('../middleware/auth');
const { createShop, getMyShops } = require('../controllers/shopController');

// ✅ Crear tienda (Protegido)
router.post("/", protect, createShop);

// ✅ Mis tiendas (Protegido)
router.get("/my-shops", protect, getMyShops);

// ✅ Listar tiendas
router.get("/", async (req, res) => {
  try {
    const shops = await Shop.find().sort({ createdAt: -1 });
    res.json(shops);
  } catch (e) {
    res.status(500).json({ message: "Error obteniendo tiendas", error: e.message });
  }
});

// ✅ Productos por tienda (Usando el Catálogo)
router.get("/:shopId/products", async (req, res) => {
  try {
    const { shopId } = req.params;
    
    // Buscar el catálogo asociado a la tienda (el modelo Catalog tiene referencia a 'shop')
    const catalog = await Catalog.findOne({ shop: shopId }).populate('products');

    if (!catalog) {
      // Si no hay catálogo, retornamos lista vacía (aunque teóricamente siempre debería haber uno)
      return res.json([]);
    }

    // Retornamos los productos del catálogo
    res.json(catalog.products);
  } catch (e) {
    console.error("Error obteniendo productos de tienda:", e);
    res.status(500).json({
      message: "Error obteniendo productos",
      error: e.message
    });
  }
});
module.exports = router;
