const express = require('express');
const router = express.Router();
const controller = require('../controllers/catalogController');

router.get('/', controller.getCatalog);


module.exports = router;