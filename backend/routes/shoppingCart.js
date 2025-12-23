const express = require('express');
const router = express.Router();
const controller = require('../controllers/shoppingCartController');

// Public: list & get
router.get('/', controller.getShoppingCart);

module.exports = router;