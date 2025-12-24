const express = require('express');
const router = express.Router();
const controller = require('../controllers/orderController');

// Public: list & get
router.get('/', controller.getAllOrders);
router.post('/create', controller.createOrder);
router.get('/client/:clientId', controller.getOrdersByClient);

module.exports = router;