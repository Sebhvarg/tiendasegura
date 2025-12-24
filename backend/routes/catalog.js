const express = require('express');
const router = express.Router();
const controller = require('../controllers/catalogController');

router.get('/', controller.getCatalog);
router.get('/search', catalogController.searchCatalog);

module.exports = router;
