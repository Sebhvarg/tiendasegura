const express = require('express');
const router = express.Router();
const controller = require('../controllers/productController');
const multer = require('multer');
const path = require('path');

// Configuración de Multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

const { protect } = require('../middleware/auth');

// Public: list & get
router.get('/', controller.getListProducts);
router.post('/create', protect, upload.single('productImage'), controller.createProduct);
router.post('/search-image', controller.searchImage);
router.delete('/:id', protect, controller.deleteProduct);
router.put('/:id', protect, upload.single('productImage'), controller.updateProduct);
// Agregar al catálogo
router.post('/:catalogId/add-to-catalog/:productId', controller.addToCatalog);

// Agregar a la lista
router.post('/:listId/add-to-list/:productId', controller.addToList);
router.get('/:id', controller.getProduct);


module.exports = router;