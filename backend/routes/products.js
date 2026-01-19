const express = require('express');
const router = express.Router();
const controller = require('../controllers/productController');


const { protect } = require('../middleware/auth');

// Public: list & get
router.get('/', controller.getListProducts);
router.post('/create', protect, controller.createProduct);
router.post('/search-image', controller.searchImage);
router.delete('/:id', protect, controller.deleteProduct);
router.put('/:id', protect, controller.updateProduct);
// Agregar al catálogo
router.post('/:catalogId/add-to-catalog/:productId', controller.addToCatalog);

// Agregar a la lista
router.post('/:listId/add-to-list/:productId', controller.addToList);
router.get('/:id', controller.getProduct);


module.exports = router;