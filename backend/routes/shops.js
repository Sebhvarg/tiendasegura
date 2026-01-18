const express = require("express");
const router = express.Router();

const Shop = require("../models/shop");
const Product = require("../models/product");

// ✅ Listar tiendas
router.get("/", async (req, res) => {
  try {
    const shops = await Shop.find().sort({ createdAt: -1 });
    res.json(shops);
  } catch (e) {
    res.status(500).json({ message: "Error obteniendo tiendas", error: e.message });
  }
});

// ✅ Productos por tienda
router.get("/:shopId/products", async (req, res) => {
  try {
    const products = await Product.find({ isActive: true }).sort({ createdAt: -1 });
    res.json(products);
  } catch (e) {
    res.status(500).json({
      message: "Error obteniendo productos",
      error: e.message
    });
  }
});
module.exports = router;
