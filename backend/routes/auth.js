const express = require('express');
const router = express.Router();
const {
  register,
  login,
  getMe,
  updateProfile,
  changePassword
} = require('../controllers/authController');
const { protect } = require('../middleware/auth');

// Rutas públicas
router.post('/register', register);
router.post('/login', login);

// Rutas protegidas (requieren autenticación)
router.get('/me', protect, getMe);
router.put('/updateprofile', protect, updateProfile);
router.put('/changepassword', protect, changePassword);

module.exports = router;
